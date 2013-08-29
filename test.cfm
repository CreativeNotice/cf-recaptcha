<cfscript>
	try{
		re = createObject("component", "recaptcha" );

		re.init( '{YourPubKeyHere}', '{YourPrivateKeyHere}' );

		WriteOutput( re.check() );

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