component {
	this.name = "presidedataobjectstests" & Hash( GetCurrentTemplatePath() );
	this.mappings[ "/presidedataobjects" ] = ExpandPath( "../presidedataobjects" );
	this.mappings[ "/testbox" ]            = ExpandPath( "./testbox" );
	this.mappings[ "/tests" ]              = ExpandPath( "./tests" );

	public void function onRequest( required string requestedTemplate ) {
		include template=arguments.requestedTemplate;
	}
}