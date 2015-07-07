component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){}

	// executes after all suites+specs in the run() method
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){

		var reader = new presidedataobjects.library.ObjectMetaReader();

		describe( "readMeta()", function(){

			it( "should return an empty array of properties when passed an empty array of filepaths", function(){
				expect( reader.readMeta( sourceFiles=[] ).properties ).tobe( [] );
			} );

			it( "should return an array of properties defined on an object", function(){
				var sourceFiles = [ "/resources/objectmetareader/object_a.cfc" ];
				var expectedResult = [
					  { "name"="label", "type"="string", "dbtype"="varchar", "maxlength"=100, "required"=true, "uniqueindexes"="title" }
					, { "name"="description", "type"="string", "dbtype"="text" }
				];

				expect( reader.readMeta( sourceFiles=sourceFiles ).properties ).tobe( expectedResult );
			} );

			it( "should merge property definitions of extended classes", function(){
				var sourceFiles = [ "/resources/objectmetareader/object_that_extends_object_a.cfc" ];
				var expectedResult = [
					  { "name"="label", "type"="string", "dbtype"="varchar", "maxlength"=100, "required"=true, "uniqueindexes"="title" }
					, { "name"="description", "type"="string", "dbtype"="text", "required"=true }
					, { "name"="newprop", "type"="boolean", "dbtype"="boolean" }
				];

				expect( reader.readMeta( sourceFiles=sourceFiles ).properties ).tobe( expectedResult );
			} );

			it( "should merge property definitions from multiple source files", function(){
				var sourceFiles = [ "/resources/objectmetareader/object_a.cfc", "/resources/objectmetareader/object_b.cfc", "/resources/objectmetareader/object_c.cfc"  ];
				var expectedResult = [
					  { "name"="label", "type"="string", "dbtype"="varchar", "maxlength"=200, "required"=true, "uniqueindexes"="title" }
					, { "name"="description", "type"="string", "dbtype"="text" }
					, { "name"="object_c_property", "type"="numeric", "required"="false" }
				];

				expect( reader.readMeta( sourceFiles=sourceFiles ).properties ).tobe( expectedResult );
			} );

		} );

	}
}