// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// READ the "A JavaScript Module Pattern"[1] article to find out about the
// module pattern used here.
//
// [1]: http://ajaxian.com/archives/a-javascript-module-pattern
//
KompilatKombinat.kultur = (KompilatKombinat.kultur || function() {

    /* private: methods and variables shall be prefixed with an '_'/underscore for
     * better readebility in the public parts */

    var _map;
    var markerHash = new Hash();
    var markerHtmlHash = new Hash();
    var iconBaseUrl = "http://maps.google.de/mapfiles/ms/micons/";

    function _addMarker(entry_id, lat, lng, icon, showInfoDirectly) {
        var point = new GPoint(lng, lat);
        var marker = new GMarker(point, icon);
        markerHash.set(entry_id, marker);
        if (showInfoDirectly) {
            _map.addOverlay(marker);
            marker.openInfoWindowHtml(markerHtmlHash.get(entry_id));
        } else {
            GEvent.addListener(marker, "mouseover", function() {
                marker.openInfoWindowHtml(markerHtmlHash.get(entry_id));
            });
            GEvent.addListener(marker, "click", function() {
                marker.openInfoWindowHtml(markerHtmlHash.get(entry_id));
            });
            _map.addOverlay(marker);
        }
    }

    /* public */
    //noinspection UnnecessaryLocalVariableJS
    var public_api = {

        init: function() {
            kk.dbg("karten init function start");
            //      kk.log("kultur init function start");
            //      google.load("maps", "2");
            //      google.setOnLoadCallback(function() {kk.kultur.load_map()});
            try {
                kk.kultur.load_map();
            } catch(e) {
                kk.err("map could not be loaded", e);
            }
        },

        load_map: function() {
            kk.dbg("load map start");
            if (GBrowserIsCompatible()) {
                //        Event.observe('kk_body','unload',function() {google.maps.Unload();})
                //        _map = new google.maps.Map2(document.getElementById("content_left"));
                //        _map.setCenter(new google.maps.LatLng(52.476000, 13.423405), 16);

                _map = new GMap2(document.getElementById("map"));

		if ($('places') != null) {
                var allObjects = $('places').select('.o_entry');
		} else {
                var allObjects = $('place').select('.o_entry');
		}
                if (allObjects != null && allObjects.length==1) {
                    var lat = allObjects[0].select('.o_lat')[0].innerHTML;
                    var lng = allObjects[0].select('.o_lng')[0].innerHTML;                    
                    _map.setCenter(new GLatLng(lat, lng), 15);
                } else {
                    if ($('map').hasClassName('moabitwest')) {
                        //            http://maps.google.de/?ie=UTF8&t=h&ll=52.529172,13.329291&spn=0.015508,0.02914&z=15
                        _map.setCenter(new GLatLng(52.528000, 13.333000), $('map').getWidth() < 500 ? 14 : 15);
                    } else {
                        _map.setCenter(new GLatLng(52.476250, 13.423405), 16);
                    }
                }

                // map type and overlay controls to zoom and move
                _map.setMapType(G_HYBRID_MAP);
                _map.addControl(new GSmallMapControl()); // small move and zoom arrows
                _map.addControl(new GScaleControl()); // map scale bar
                _map.addControl(new GMapTypeControl()); // maptye chooser

                // read in the object data from DOM tree and place them as marker on the map
                if (allObjects != null && allObjects.length>0) {
                    kk.kultur.addAllMarkerOfSpecifiedType2(allObjects);
                }
                //        kk.kultur.addAllMarkerOfSpecifiedType2('shop');
                //        kk.kultur.addAllMarkerOfSpecifiedType2('event');
            }
        },

        get_map: function() {
            return _map;
        },

        show: function(o_id) {
            alert("show " + o_id);
            alert("show " + markerHash.get(o_id));
            alert("show " + markerHtmlHash.get(o_id));
            markerHash.get(o_id).openInfoWindowHtml(markerHtmlHash.get(o_id));
            return true;
        },

        /* Example Object:
         <div class="artist">
         <ul id="1">
         <li class="o_name">Schillerpalais</li>
         <li class="o_desc">
         "Schillerpalais - Kunst- und Aktionsraum: Als Kulturbüro steht das
         Schillerpalais Initiativen und Einzelpersonen, die Kunst machen,
         fördern, unterstützen und organisieren wollen zur Mitarbeit und
         Nutzung seiner Infrastruktur offen."
         </li>
         <li class="o_adr">Schillerpromenade 4, 12049 Berlin</li>
         <li class="o_www">www.schillerpalais.de</li>
         <li class="o_post">info[at]schillerpalais.de</li>
         <li class="o_tel">(030) 62 72 46 70 - 46 73</li>
         </ul>
         </div>

         geocode manually:
         http://maps.google.com/maps/geo?q=Schillerpromenade+4,+12049+Berlin&output=xml&key=ABQIAAAA_GbY_QkQO7FpSpCc35mmQxQD5s9Mko_TQLVGhUivsGN8DVz4jBTT26eZMsNvoSxZZ-qTEcUHJme2Yg
         new key for beleben.de: ABQIAAAA_GbY_QkQO7FpSpCc35mmQxSdAa59Iy4tysMkBtxkgxFcQ-h6hhRVQuo5_9rNgK-wW7ymD_00daYOWg
         */
        addAllMarkerOfSpecifiedType2: function(allObjects) {

            var icon = new GIcon(G_DEFAULT_ICON);
            icon.iconSize = new GSize(32, 32);
            icon.iconAnchor = new GPoint(16, 32);
            icon.shadowSize = new GSize(59, 32);
            icon.shadow = iconBaseUrl + "msmarker.shadow.png"
            icon.image = iconBaseUrl + "blue-dot.png";

            allObjects.each(function(entry, index) {
                try {
                    kk.log(index + ": " + entry.toString() + "(id=" + entry.id + ")");
                    var title = entry.select('.o_title')[0].innerHTML;
                    var rating = entry.select('.current_rating')[0].getStyle('width');
                    var address = entry.select('.o_address')[0].innerHTML;
                    var lat = entry.select('.o_lat')[0].innerHTML;
                    var lng = entry.select('.o_lng')[0].innerHTML;
                    var tags = entry.select('.o_tags')[0].innerHTML;
                    var details = '';
                    try {
                        details = entry.select('.o_show')[0].getAttribute('href');
                    } catch(e) {
                    }
                    var markerHtml = "<div class='marker_info'>"
                            + "<h4>" + title + ""
                            + "<ul class='stars' style='float:right;margin-right:10px;'><li class='current_rating' style='width:" + rating + "'>" + rating + "</li></ul></h4>"
                            + "<div>" + tags + "</div><hr/>"
                            + "<p>" + address + "</p>";
                    if (details.length > 0) {
                        markerHtml += "<a class='o_show' href='" + details + "'>Detailseite anzeigen</a>";
                    }
                    markerHtml += "</div>";
                    kk.log(index + ": " + markerHtml);
                    markerHtmlHash.set(entry.id, markerHtml);

                    if ('&nbsp;' != address && '' != address) {
                        // timeout is needed because GClientGeocoder does not accept more than 10 request at once
//                        window.setTimeout(function() {
                            _addMarker(entry.id, lat, lng, icon, allObjects.length == 1);
//                        }, 250 * index);
                    }
                } catch(e) {
                    kk.err(e);
                }
            });
        }

    }; // public api.

    return public_api;
}());
