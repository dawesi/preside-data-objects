/**
 * Class to store all compiled objects and provide
 * access to them.
 *
 * Accepts an array of source directories from which
 * it will scan for object files and compile them.
 *
 */
component {

	/**
	 * Constructor. Takes a reference to the object framework + an array of directories
	 * from which to scan for object files.
	 *
	 * Compiles the library and returns reference to self.
	 *
	 */
	public any function init( required any framework, required array sourceDirectories ) {
		_buildLibrary( argumentCollection = arguments );

		return this;
	}

	/**
	 * Returns an array of compiled object names that exist in the library
	 *
	 */
	public array function listObjects() {
		return _getObjects().keyArray();
	}

// PRIVATE HELPERS
	private void function _buildLibrary( required any framework, required array sourceDirectories ) {
		var objects            = {};
		var objectMap          = new MultipleDirectoryObjectScanner().scanDirectories( directories = arguments.sourceDirectories );
		var compiler           = new ObjectCompiler( framework = arguments.framework );
		var relationshipHelper = new RelationshipHelper();

		for( var objectName in objectMap ){
			objects[ objectName ] = compiler.compileObject( objectName=objectName, sourceFiles=objectMap[ objectName ] );
		}

		relationshipHelper.createAutoPivotObjects( objects=objects, compiler=compiler );

		_setObjects( objects );

	}

// ACCESSORS
	private struct function _getObjects() {
		return _objects;
	}
	private void function _setObjects( required struct objects ) {
		_objects = arguments.objects;
	}

}