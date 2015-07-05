/**
 * Class that provides logic for recursively scanning multiple directories
 * in search of preside object files and returning a map of those files in the form of
 * { objectname = [ '/path/to/objectname.cfc', '/different/path/to/objectname.cfc' ], ... }
 *
 *
 */
component {

	public array function scanDirectories( required array directories ) {
		return [];
	}

}