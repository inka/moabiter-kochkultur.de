# Taken from
# http://www.samsaffron.com/archive/2008/02/02/Redo+your+migrations+in+Rails+and+keep+your+data
#
# RAILS_ENV=production rake db:backup:write
# .. dumps all your data into yaml files in db/backup
#
# RAILS_ENV=production rake db:backup:read
# .. overwrite your current db with table data from db/backup yaml files
#
# RAILS_ENV=production rake db:backup:redo
# .. writes new backup, drop db, recreate, migrate the schema and load the data

namespace :db do
  namespace :backup do

    def interesting_tables
      ActiveRecord::Base.connection.tables.sort.reject! do |tbl|
        ['schema_info', 'sessions', 'public_exceptions'].include?(tbl)
      end
    end

    def skip_tables
        ['schema_info', 'sessions', 'public_exceptions']
    end

    desc "Reload the database and rerun migrations without dataloss"
    task :redo do
      Rake::Task['db:backup:write'].invoke
      Rake::Task['db:drop'].invoke
      Rake::Task['db:create'].invoke
      Rake::Task['db:migrate'].invoke
      Rake::Task['db:backup:read'].invoke
    end

    desc "Dump entire db."
    task :write => :environment do

      require 'rubygems'      
      require 'ya2yaml'

      dir = RAILS_ROOT + '/db/backup'
      FileUtils.mkdir_p(dir)
      FileUtils.chdir(dir)

      sql  = "SELECT * FROM %s"
      ActiveRecord::Base.establish_connection
      (ActiveRecord::Base.connection.tables - skip_tables).each do |table_name|
        i = "000"
        File.open("#{table_name}.yml", 'w') do |file|
          data = ActiveRecord::Base.connection.select_all(sql % table_name)
          file.write data.inject({}) { |hash, record|
            hash["#{table_name}_#{i.succ!}"] = record
            hash
          }.ya2yaml
        end
      end

#      interesting_tables.each do |tbl|
#
#        klass = tbl.classify.constantize
#        puts "Writing #{tbl}..."
#        File.open("#{tbl}.yml", 'w+') { |f| YAML.dump klass.find(:all).collect(&:attributes), f }
#      end
      FileUtils.chdir(RAILS_ROOT)
    end

    desc "Loads the entire db."
    task :read => :environment do
      require 'active_record/fixtures'

      ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
      (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(RAILS_ROOT, 'db', 'backup', '*.{yml,csv}'))).each do |fixture_file|
        Fixtures.create_fixtures('db/backup', File.basename(fixture_file, '.*'))
      end

#      interesting_tables.each do |tbl|
#
#        klass = tbl.classify.constantize
#        ActiveRecord::Base.transaction do
#
#          puts "Loading #{tbl}..."
#          YAML.load_file("#{tbl}.yml").each do |fixture|
#            data = {}
#            klass.columns.each do |c|
              # filter out missing columns
#              data[c.name] = fixture[c.name] if fixture[c.name]
#            end
#            ActiveRecord::Base.connection.execute "INSERT INTO #{tbl} (#{data.keys.join(",")}) VALUES (#{data.values.collect { |value| ActiveRecord::Base.connection.quote(value) }.join(",")})", 'Fixture Insert'
#
#        end
#        end
#      end

    end

  end
end
