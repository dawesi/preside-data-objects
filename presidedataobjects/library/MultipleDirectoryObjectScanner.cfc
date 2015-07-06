/**
 * Class that provides logic for recursively scanning multiple directories
 * in search of preside object files and returning a map of those files in the form of
 * { objectname = [ '/path/to/objectname.cfc', '/different/path/to/objectname.cfc' ], ... }
 *
 *
 */
component {

	/**
	 * Scans a list of directories for object files. Returns a structure who's keys are
	 * object names (bare filenames) and who's values are an array of mapped file paths
	 * to all instances of CFC files for the object (there may be multiple due to multiple
	 * directories)
	 *
	 * @directories.hint Array of mapped paths to directories in which to scan for object files
	 *
	 */
	public struct function scanDirectories( required array directories ) {
		var map = {};

		for( var dir in arguments.directories ) {
			var fullDirPath     = ExpandPath( dir );
			var objectFilePaths = DirectoryList( fullDirPath, true, 'path', "*.cfc" );

			for( var objectFilePath in objectFilePaths ){
				var objectName = ReReplace( ListLast( objectFilePath, "\/" ), "\.cfc$", "" );
				var mappedPath = dir & Replace( Replace( objectFilePath, fullDirPath, "" ), "\", "/", "all" );

				map[ objectName ] = map[ objectName ] ?: [];
				map[ objectName ].append( mappedPath );
			}
		}

		return map;
	}
}