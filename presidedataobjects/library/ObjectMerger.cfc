/**
 * Class that provides logic for merging two object instances
 *
 */
component {

	/**
	 * Merges all the methods from `objectToMerge` into `targetObject`
	 *
	 * @targetObject.hint Object that will receive all the methods from `objectToMerge`
	 * @objectToMerge.hint Object who's methods will all be merged into `targetObject`
	 *
	 */
	public void function mergeObjects( required any targetObject, required any objectToMerge ) {
		targetObject.$addFunction    = this.$addFunction;
		objectToMerge.$mixinFunctions = this.$mixinFunctions;

		objectToMerge.$mixinFunctions( targetObject );

		StructDelete( targetObject, "$addFunction"      );
		StructDelete( objectToMerge, "$mixinFunctions" );
	}

// MIXIN HELPERS
	public void function $addFunction( required string name, required function func ) {
		this[ name ] = func;
		variables[ name ] = func;
	}

	public void function $mixinFunctions( target, objMeta = getMetaData( this ) ) {
		if ( StructKeyExists( objMeta, "extends" ) ) {
			this.$mixinFunctions( target, objMeta.extends );
		}

		if ( StructKeyExists( objMeta, "functions" ) ) {
			for( var func in objMeta.functions ) {
				target.$addFunction( func.name, this[ func.name ] );
			}
		}
	}
}