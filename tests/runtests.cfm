<cfscript>
	isCli = ReFindNoCase( "^CLI\/", cgi.server_protocol );

	function exitCode( required numeric code ) {
		var exitcodeFile = GetDirectoryFromPath( GetCurrentTemplatePath() ) & "/.exitcode";
		FileWrite( exitcodeFile, code );
	}

	try {
		reporter = isCli ? "text" : "simple";
		testbox  = new testbox.system.TestBox( options={}, reporter=reporter, directory={
			  recurse  = true
			, mapping  = "tests"
			, filter   = function( required path ){ return true; }
		} );

		echo( testbox.run() );

		if ( isCli ) {
			resultObject = testbox.getResult();
			errors       = resultObject.getTotalFail() + resultObject.getTotalError();
			exitCode( errors ? 1 : 0 );
		}

	} catch ( any e ) {
		if ( isCli ) {
			echo( "An error occurred running the tests. Message: [#e.message#], Detail: [#e.detail#]" );
			exitCode( 1 );
		} else {
			rethrow;
		}
	}
</cfscript>