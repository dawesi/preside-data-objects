/**
 * Class that provides logic for reading various bits of metadata from objects
 * including properties and object attributes.
 *
 */
component extends="presidedataobjects.util.Base" {

	/**
	 * Returns an structure compiled metadata (attributes and properties)
	 * from all of the source files that make up the object
	 *
	 * @sourceFiles.hint array of source files for the object
	 *
	 */
	public struct function readMeta( required array sourceFiles ) {
		var meta = {
			  properties = []
			, attributes = {}
		};

		for( var sourceFilePath in arguments.sourceFiles ) {
			var objectPath     = Replace( ReReplace( sourceFilePath, "^/(.*?)\.cfc$", "\1" ), "[/]", ".", "all" );
			meta = _parseComponentMetaData( GetComponentMetaData( objectPath ), sourceFilePath );
		}

		return meta;
	}

// PRIVATE UTILITY
	private struct function _parseComponentMetaData( required struct meta, required string filepath ) {
		var parsed = { properties=[] };

		if ( ( arguments.meta.extends ?: {} ).count() ) {
			parsed = _parseComponentMetaData( arguments.meta.extends, arguments.meta.extends.path );
		}

		var objectProps  = Duplicate( arguments.meta.properties ?: [] );
		var orderedProps = _getPropertyNamesInOrder( filepath );

		objectProps.sort( function( a, b ){
			return orderedProps.find( a.name ?: "" ) > orderedProps.find( b.name ?: "" ) ? 1 : -1;
		} );

		for( var prop in objectProps ) {
			var existingIndex = parsed.properties.find( function( existingProp ){
				return ( existingProp.name ?: "" ) == ( prop.name ?: "" );
			} );

			if ( existingIndex ) {
				parsed.properties[ existingIndex ].append( prop );
			} else {
				parsed.properties.append( Duplicate( prop ) );
			}
		}

		return parsed;
	}

	private array function _getPropertyNamesInOrder( required string pathToCfc ) output=false {
		var cfcContent      = FileRead( arguments.pathToCfc );
		var propertyMatches = _reSearch( 'property\s+[^;/>]*name="([a-zA-Z_\$][a-zA-Z0-9_\$]*)"', cfcContent );

		if ( StructKeyExists( propertyMatches, "$1" ) ) {
			return propertyMatches.$1;
		}

		return [];
	}


}