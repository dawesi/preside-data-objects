component {
	this.name = "presidedataobjectstests" & Hash( GetCurrentTemplatePath() );
	this.mappings[ "/presidedataobjects" ] = ExpandPath( "../presidedataobjects" );
	this.mappings[ "/testbox" ]            = ExpandPath( "./testbox" );
	this.mappings[ "/tests" ]              = ExpandPath( "./tests" );
	this.mappings[ "/resources" ]          = ExpandPath( "./resources" );

	public void function onRequest( required string requestedTemplate ) {
		include template=arguments.requestedTemplate;
	}
}