// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// READ the "A JavaScript Module Pattern"[1] article to find out about the
// module pattern used here.
//
// [1]: http://ajaxian.com/archives/a-javascript-module-pattern
//
var KompilatKombinat = (window.KompilatKombinat || (function() {

    /* private: methods and variables shall be prefixed with an '_'/underscore for
     * better readebility in the public parts */
    var _sInputClass = 'populate'; // Class name for input elements to autopopulate
    var _sHiddenClass = 'structural'; // Class name that gets assigned to hidden label elements
    var _bHideLabels = true; // If true, labels are hidden

    /** basic logger function which wraps the call in the console logger. With a
     * twist though: when 'msg' is an object it will be converted into an JSON
     * string before beeing printed */
    function _log(level, msg, prefix) {
        if (typeof console == 'undefined') {
            return;
        }
        try {
            var f = console[level];
            if (typeof msg == 'string') {
                f(msg);
            } else {
                //msg = prefix + ": {" + o_to_s(msg) + "}";
                var txt = Object.toJSON(msg);
                if (txt == "{}") {
                    f((prefix || ':') + ': ');
                    f(msg);
                } else {
                    f((prefix || ':') + ": " + txt);
                }
            }
            //} catch(e) { ee.err(e, e.message); }//console.error(e); }
        } catch(e) {
            console.error(e);
        }
    }

    /* public */
    //noinspection UnnecessaryLocalVariableJS
    var public_api = {

        /** log level helpers */
        log:  function(msg, prefix) {
            _log('info', msg, prefix);
        },
        dbg:  function(msg, prefix) {
            _log('debug', msg, prefix);
        },
        err:  function(msg, prefix) {
            _log('error', msg, prefix);
        },
        warn: function(msg, prefix) {
            _log('warn', msg, prefix);
        },

        init: function() {
            kk.log("global init function start");
            //    google.load("prototype", "1.6");
            //    google.load("scriptaculous", "1.8.1");
            kk.kultur.init();

            $$('ul.stars').each(function (el) {
                Event.observe($(el), 'mouseover', function() {
                    $(el).down('.current_rating').hide();
                    $(el).next('.click').show();
                });
                Event.observe($(el), 'mouseout', function() {
                    $(el).next('.click').hide();
                    $(el).down('li.current_rating').show();
                });
            });

            $$('.shownewcomment').each(function(el) {
                $(el).observe('click', function() {
                    Effect.toggle($('newcomment').down('div'), 'blind', { duration: 1.0 });
                });
            });
        },

        cat_toggle: function(typeStr) {
            // toggle the div box with objects of typeStr inside
            $(typeStr).toggle();
            //    alert(typeStr + " toggled");
            return true;
        },

        contact_validate: function() {
            if (document.f.vorname.value == "") {
                alert("Bitte Ihren Vornamen eingeben!");
                document.f.vorname.focus();
                return false;
            }
            if (document.f.nachname.value == "") {
                alert("Bitte Ihren Nachnamen eingeben!");
                document.f.nachname.focus();
                return false;
            }
            if (document.f.email.value == "") {
                alert("Bitte Ihre E-Mail-Adresse eingeben!");
                document.f.email.focus();
                return false;
            }
            if (document.f.email.value.indexOf("@") == -1) {
                alert("Bitte geben Sie eine gültige E-Mail-Adresse ein!");
                document.f.email.focus();
                return false;
            }
            if (document.f.nachricht.value == "") {
                alert("Bitte schildern Sie kurz Ihr Anliegen!");
                document.f.nachricht.focus();
                return false;
            }
            return true;
        },

        getLabel:function(e) {
            return e.up('li', 0).down('label');
        },

        /**
         * Copy the value of an input field's title attribute to its value attribute.
         * Clear the input field on focus if its value is the same as its title.
         * Repopulate the input field on blur if it is empty.
         * Hide the input field's associated label if it has one.
         */
        autoPopulate:function() {
            // Check for DOM support
            if (!document.getElementById || !document.createTextNode) {
                return;
            }
            // Find all input elements with the given className
            $$('.' + _sInputClass).each(function(oInput) {
                // Make sure it's a text input
                // if (oInput.type != 'text') { continue; }
                // Hide the input's label
                if (_bHideLabels) {
                    kk.getLabel(oInput).addClassName(_sHiddenClass);
                }
                // If value is empty and title is not, assign title to value
                if ((oInput.value == '')) {
                    oInput.value = kk.getLabel(oInput).innerHTML;
                    Element.addClassName(oInput, 'inputLabel');
                }
                // Add event handlers for focus and blur
                Event.observe(oInput, 'focus', function() {
                    // If value and title are equal on focus, clear value
                    if (this.value == kk.getLabel(this).innerHTML) {
                        this.value = '';
                        this.select(); // Make input caret visible in IE
                        Element.removeClassName(this, 'inputLabel');
                    }
                });
                Event.observe(oInput, 'blur', function() {
                    // If the field is empty on blur, assign title to value
                    if (!this.value.length) {
                        this.value = kk.getLabel(this).innerHTML;
                        Element.addClassName(this, 'inputLabel');
                    }
                });
            })
            Event.observe($$('form')[0], 'submit', function() {
                $$('.' + _sInputClass).each(function (el) {
                    if (el.value == kk.getLabel(el).innerHTML) {
                        el.value = '';
                        Element.removeClassName(el, 'inputLabel');
                    }
                })
            });
        }
    }; // public api.

    return public_api;
}()));

var kk = KompilatKombinat; // shortcut
