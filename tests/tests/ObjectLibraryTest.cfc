component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){}

	// executes after all suites+specs in the run() method
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){

		var dirs    = [ "/resources/objectlibrary/testdir1", "/resources/objectlibrary/testdir2", "/resources/objectlibrary/testdir3" ];
		var mockFw  = getMockbox().createStub();
		var library = new presidedataobjects.library.ObjectLibrary( framework = mockFw, sourceDirectories=dirs );

		describe( "listObjects()", function(){

			it( "should return an array of object names found in the library including auto pivot objects", function(){
				expect( library.listObjects().sort( "textnocase" ) ).toBe( [
					  "object_a"
					, "object_a__join__object_b"
					, "object_b"
					, "object_b_ds"
					, "object_c"
					, "object_d"
				] );
			} );

		} );

		describe( "objectExists()", function(){

			it( "should return false when the passed object does not exist", function(){
				expect( library.objectExists( "meh" ) ).toBe( false );
			} );

			it( "should return true when the passed object does exist", function(){
				expect( library.objectExists( "object_a__join__object_b" ) ).toBe( true );
			} );

		} );

		describe( "getObject()", function(){

			it( "should return the given object found by name", function(){
				var obj = library.getObject( "object_b_ds" );

				expect( obj.getObjectName() ).toBe( "object_b_ds" );
				expect( obj.getAttribute( "dynamic" ) ).toBe( true );
			} );

			it( "should throw an informative error when the object does not exist", function(){
				expect( function(){
					library.getObject( "meh" );
				} ).toThrow( "presidedataobjects.library.objectnotfound" );
			} );
		} );

		describe( "getObjects()", function(){

			it( "should return structure of objects with keys as object names and objects as values", function(){
				var objects = library.getObjects();

				expect( objects.object_a.getObjectName() ).toBe( "object_a" );
				expect( objects.object_a.getAttribute( "dynamic", false ) ).toBe( false );
			} );

		} );
	}
}
