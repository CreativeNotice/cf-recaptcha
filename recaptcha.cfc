/**
* @displayname reCaptcha
* @description Simple CFC allowing you to easily use Google's reCAPTCHA API. 
* @author      Ryan Mueller
* @created     08/28/2013
* @version     1.0
*
* @see https://developers.google.com/recaptcha/intro
*
* @output    false
* @accessors true
*
* @todo      1. Need to add support for custom_theme_widget
*/

component {

	/* --------------------------------------------------------------------------------
	 * Properties
	 * --------------------------------------------------------------------------------
	 * We have to set these defaults in the init() function since the default attribute
	 * of a property doesn't actually take effect unless the CFC is a persistent object.
	 * Rather than take a chance that setting this CFC to persistent could cause conflicts
	 * for developers using ORM in their application, we're just going to set defaults 
	 * the old fashioned way.
	 */
	
	/**
	 * @displayname HTTP Type
	 * @hint        Set this to http: or https: depending on your site's use of SSL certificate.
	 * @default     http:
	 */
	property string http_type;
	
	/**
	 * @displayname Check URL
	 * @hint        Set this to the non-secure Google API endpoint
	 * @default     //www.google.com/recaptcha/api/challenge
	 */
	property string check_url;

	/**
	 * @displayname No Script URL
	 * @hint        Set this to the no-script Google API endpoint
	 * @default     //www.google.com/recaptcha/api/noscript
	 */
	property string noscript_url;

	/**
	 * @displayname Verify URL
	 * @hint        Set this to the verify Google API endpoint
	 * @default     //www.google.com/recaptcha/api/verify
	 */
	property string verify_url;

	/**
	 * @displayname API Key Public
	 * @hint        Set this to your public API key from Google. Obtain at https://www.google.com/recaptcha/admin/list
	 */
	property string api_key_public;

	/**
	 * @displayname API Key Private
	 * @hint        Set this to your private API key from Google. Obtain at https://www.google.com/recaptcha/admin/list
	 */
	property string api_key_private;

	/**
	 * @displayname Theme
	 * @hint        You may specify the theme: 'red' | 'white' | 'blackglass' | 'clean' | 'custom'
	 * @see         https://developers.google.com/recaptcha/docs/customization
	 */
	property string theme;

	/**
	 * @displayname Lang
	 * @hint        You may specify the language. E.g. 'en'
	 * @see         https://developers.google.com/recaptcha/docs/customization
	 */
	property string lang;

	/**
	 * @displayname Tab Index
	 * @hint        Specify tab index for the input field. Defaults to empty.
	 * @see         https://developers.google.com/recaptcha/docs/customization
	 */
	property string tab_index;

	/**
	 * @displayname Error Code
	 * @hint        This should hold any any error code returned from the verify request.
	 * @see         https://developers.google.com/recaptcha/docs/verify
	 */
	property string err_code;

	// @TODO: Need to add support for custom_theme_widget

	/* -----------------------------------------------------------------------------------
	 * Methods
	 * -----------------------------------------------------------------------------------
	 */

	init();

	/**
	 * @displayname Init
	 * @description With this method we bootstrap the component.
	 * @hint        Set the default API endpoints here. But you can override them in your code by setting explicitly by calling the init() method directly.
	 * @returntype  Void
	 */
	public function init( 
		required string pub_key    = '',
		required string priv_key   = '',
		required string theme      = 'red',
		required string lang       = 'en',
		required numeric tab_index = -1,
		required string http       = '',
		required string check      = '//www.google.com/recaptcha/api/challenge',
		required string noscript   = '//www.google.com/recaptcha/api/noscript',
		required string verify     = '//www.google.com/recaptcha/api/verify'
		){

		// Set the API keys 
		this.setApi_key_public( trim( arguments.pub_key ) );
		this.setApi_key_private( trim( arguments.priv_key ) );

		// Set the API endpoint defaults
		this.setCheck_url( trim( arguments.check ) );
		this.setNoScript_url( trim( arguments.noscript ) );
		this.setVerify_url( trim( arguments.verify ) );

		// Set other defaults
		this.setTheme( trim( arguments.theme ) );
		this.setLang( trim( arguments.lang ) );
		this.setTab_index( arguments.tab_index );

		// If no http type was passed in, default to what the server says in cgi.https
		var http_string = trim( arguments.http );
		http_string = ( len(http_string) == 0 && cgi.https == 'on' ) ? 'https:' : 'http:';
		this.setHTTP_type( http_string );
	};

	/**
	 * @displayname Display
	 * @description Will output, or return string, the reCAPTCHA html.
	 * @returnType  String
	 * @output      true
	 */
	public function display( string pub_key, string priv_key, string theme, string lang, numeric tab_index ){

		if( structKeyExists(arguments,'pub_key') )  { this.setApi_key_public( trim(arguments.pub_key) ); }
		if( structKeyExists(arguments,'priv_key') ) { this.setApi_key_private( trim(arguments.priv_key) ); }
		if( structKeyExists(arguments,'theme') )    { this.setTheme( trim(arguments.theme) ); }
		if( structKeyExists(arguments,'lang') )     { this.setLang( trim(arguments.lang) ); }
		if( structKeyExists(arguments,'tab_index') ) { this.setTab_index( arguments.tab_index ); }

		var error     = ( len(this.getErr_code()) > 0 ) ? '&error='& this.getErr_code() : '';
		var noscript  = this.getHTTP_type() & this.getNoScript_url() &'?k='& this.getApi_key_public() & error;
		var challenge = this.getHTTP_type() & this.getCheck_url() &'?k='& this.getApi_key_public() & error;

		// Build options object
		var options = {
			'lang'  = this.getLang(),
			'theme' = this.getTheme()
		};
		if( this.getTab_index() >= 0 ){ options['tabindex'] = this.getTab_index(); }

		// Setup the output
		savecontent variable='out' {
			writeOutput( '<script>var RecaptchaOptions = '& serializeJSON( options ) &';</script>' );
			WriteOutput( '<script src="'& challenge &'"></script>' );
			WriteOutput( '
				<noscript>
					<iframe src="'& noscript &'" height="300" width="500" frameborder="0"></iframe><br>
					<textarea name="recaptcha_challenge_field" rows="3" cols="40"></textarea>
					<input type="hidden" name="recaptcha_response_field" value="manual_challenge">
				</noscript>
			' );
		};

		WriteOutput( out );
	};

	/**
	 * @displayname Check
	 * @description Will check if the reCAPTCHA was filled out and then send a check request to the API endpoint. We'll return false, and set the error if needed.
	 * @returnType  Boolean
	 */
	public function check( string pub_key, string priv_key ){

		if( structKeyExists(arguments,'pub_key') )  { this.setApi_key_public( trim(arguments.pub_key) ); }
		if( structKeyExists(arguments,'priv_key') ) { this.setApi_key_private( trim(arguments.priv_key) ); }
		if( structKeyExists(form, 'recaptcha_challenge_field') && structKeyExists(form, 'recaptcha_response_field') ){

			var h = new http();
			h.setMethod( 'post' );
			h.setCharset( 'utf-8' );
			h.setUrl( this.getHTTP_type() & this.getVerify_url() );
			h.addParam( type='formfield', name='privatekey', value=this.getApi_key_private() );
			h.addParam( type='formfield', name='remoteip',   value=cgi.remote_addr );
			h.addParam( type='formfield', name='challenge',  value=form.recaptcha_challenge_field );
			h.addParam( type='formfield', name='response',   value=form.recaptcha_response_field );

			var api_response = h.send().getPrefix();

			if( val(api_response.statuscode) == 200 ){

				// Let's check the response then, we split on \n
				var response = listToArray(api_response.filecontent, chr(10) );

				if( response[1] == 'true' ){

					return TRUE;

				}else{

					// reCAPTCHA returned an error so we'll set the error code verbatim
					this.setErr_code( response[2] );
					return FALSE;

				}

			}else{

				// we got a bad HTTP status code so we'll just say reCAPTCHA was unreachable
				this.setErr_code( 'recaptcha-not-reachable' );
				return FALSE;
			}

		}else{

			return FALSE;
		}
	};
}