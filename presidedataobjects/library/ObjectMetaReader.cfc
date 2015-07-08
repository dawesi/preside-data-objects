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
			var objectPath = Replace( ReReplace( sourceFilePath, "^/(.*?)\.cfc$", "\1" ), "[/]", ".", "all" );
			var objectMeta = _parseComponentMetaData( GetComponentMetaData( objectPath ), sourceFilePath );

			_mergeMeta( meta, objectMeta );
		}

		_removeDeleteProps( meta );

		return meta;
	}

// PRIVATE UTILITY
	private struct function _parseComponentMetaData( required struct meta, required string filepath ) {
		var parsed   = { properties=[], attributes={} };
		var extended = { properties=[], attributes={} };
		var ignoredAttributes = [ "output", "extends", "persistent", "accessors", "hint", "remoteAddress", "path", "displayName", "synchronized", "fullname", "name", "type", "hashcode" ];

		if ( ( arguments.meta.extends ?: {} ).count() ) {
			parsed = _parseComponentMetaData( arguments.meta.extends, arguments.meta.extends.path );
		}

		var objectProps  = Duplicate( arguments.meta.properties ?: [] );
		var orderedProps = _getPropertyNamesInOrder( filepath );

		objectProps.sort( function( a, b ){
			return orderedProps.find( a.name ?: "" ) > orderedProps.find( b.name ?: "" ) ? 1 : -1;
		} );

		for( var prop in objectProps ) {
			extended.properties.append( prop );
		}

		for( var attribute in arguments.meta ) {
			if ( IsSimpleValue( arguments.meta[ attribute ] ) && !ignoredAttributes.findNoCase( attribute ) ) {
				extended.attributes[ attribute ] = arguments.meta[ attribute ];
			}
		}

		_mergeMeta( parsed, extended );

		return parsed;
	}

	private void function _mergeMeta( required struct sourceMeta, required struct metaToMerge ) {
		for( var prop in metaToMerge.properties ) {
			var existingIndex = sourceMeta.properties.find( function( existingProp ){
				return ( existingProp.name ?: "" ) == ( prop.name ?: "" );
			} );

			if ( existingIndex && IsBoolean( prop.deleted ?: "" ) && prop.deleted ) {
				sourceMeta.properties.deleteAt( existingIndex );
			} else {
				if ( existingIndex ) {
					_mergeProperties( sourceMeta.properties[ existingIndex ], prop );
				} else {
					sourceMeta.properties.append( Duplicate( prop ) );
				}
			}
		}

		sourceMeta.attributes.append( metaToMerge.attributes );
	}

	private void function _mergeProperties( required struct sourceProperty, required struct propertyToMerge ) {
		for( var attribute in propertyToMerge ) {
			var ignoreProperty = attribute == "type" && propertyToMerge[ attribute ] == "any";

			if ( !ignoreProperty ) {
				sourceProperty[ attribute ] = propertyToMerge[ attribute ];
			}
		}
	}

	private array function _getPropertyNamesInOrder( required string pathToCfc ) {
		var cfcContent      = FileRead( arguments.pathToCfc );
		var propertyMatches = _reSearch( 'property\s+[^;/>]*name="([a-zA-Z_\$][a-zA-Z0-9_\$]*)"', cfcContent );

		if ( StructKeyExists( propertyMatches, "$1" ) ) {
			return propertyMatches.$1;
		}

		return [];
	}

	private void function _removeDeleteProps( required struct meta ) {
		for( var i=meta.properties.len(); i>0; i-- ) {
			var prop = meta.properties[ i ];

			if ( IsBoolean( prop.deleted ?: "" ) && prop.deleted ) {
				meta.properties.deleteAt( i );
			}
		}
	}


}