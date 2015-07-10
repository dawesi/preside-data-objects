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
	 * @framework.hint         Reference to the preside data objects Framework. Used by the object compiler to allow objects access to core framework methods.
	 * @sourceDirectories.hint Array of mapped directory paths that contain your application's object files
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

	/**
	 * Returns whether or not the given object exists
	 *
	 * @objectName.hint The name of the object
	 */
	public boolean function objectExists( required string objectName ) {
		return _getObjects().keyExists( arguments.objectName );
	}

	/**
	 * Returns the given object. Throws an "presidedataobjects.library.objectnotfound"
	 * error when the object does not exist
	 *
	 * @objectName.hint The name of the object
	 */
	public any function getObject( required string objectName ) {
		var objects = _getObjects();
		return objects[ arguments.objectName ] ?: throw( type="presidedataobjects.library.objectnotfound", message="The object [#arguments.objectName#] could not be found in the Preside Data Objects library.", detail="Existing objects are: #SerializeJson( objects.keyArray() )#" );
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