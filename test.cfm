<cfscript>
	try{
		re = createObject("component", "recaptcha" );

		re.init( '6LfMruYSAAAAAE43dj7bBkUfqE5ihgrAyZ9vnZE0', '6LfMruYSAAAAACR_7fPOe2-6N5rdniqlI-P_KKB4' );

		re.check();

	}catch( any e ){
		WriteDump( e );
	}
</cfscript>
<cfoutput>
	<form action="" method="post">
		
		<cfscript>re.display();</cfscript>
		<button type="submit" class="btn">Send</button>

	</form>

</cfoutput>