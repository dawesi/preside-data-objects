/**
 * Class that provides logic for reading property attributes from an object
 *
 */
component extends="presidedataobjects.util.Base" {

	/**
	 * Returns an array of properties (structures) that are defined in the
	 * object's source files
	 *
	 * @sourceFiles.hint array of source files for the object
	 *
	 */
	public array function readProperties( required array sourceFiles ) {
		var properties = [];

		for( var sourceFilePath in arguments.sourceFiles ) {
			var objectPath   = Replace( ReReplace( sourceFilePath, "^/(.*?)\.cfc$", "\1" ), "[/]", ".", "all" );
			var meta         = GetComponentMetaData( objectPath );
			var objectProps  = Duplicate( meta.properties ?: [] );
			var orderedProps = _getOrderedPropertiesInAHackyWayBecauseLuceeGivesThemInRandomOrder( sourceFilePath );

			objectProps.sort( function( a, b ){
				return orderedProps.find( a.name ?: "" ) > orderedProps.find( b.name ?: "" ) ? 1 : -1;
			} );

			for( var prop in objectProps ) {
				properties.append( Duplicate( prop ) );
			}
		}

		return properties;
	}

// PRIVATE UTILITY
	private array function _getOrderedPropertiesInAHackyWayBecauseLuceeGivesThemInRandomOrder( required string pathToCfc ) output=false {
		var cfcContent      = FileRead( arguments.pathToCfc );
		var propertyMatches = _reSearch( 'property\s+[^;/>]*name="([a-zA-Z_\$][a-zA-Z0-9_\$]*)"', cfcContent );

		if ( StructKeyExists( propertyMatches, "$1" ) ) {
			return propertyMatches.$1;
		}

		return [];
	}
}