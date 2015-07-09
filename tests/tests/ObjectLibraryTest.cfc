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
	}
}
