component extends="testbox.system.BaseSpec"{
	function beforeAll(){}

	// executes after all suites+specs in the run() method
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){
		var helper = new presidedataobjects.library.RelationshipHelper();

		describe( "createAutoPivotObjects", function(){

			it( "should create any missing pivot objects based on relationship properties of the existing objects", function(){
				var objects = {
					  object_a = getMockbox().createStub()
					, object_b = getMockbox().createStub()
					, object_c = getMockbox().createStub()
					, object_d = getMockbox().createStub()
				};
				var object_a_props = { bs={ name="bs", relationship="many-to-many", relatedTo="object_b", relatedvia="nonexistantpivot" }, cs={ name="cs", relationship="many-to-many", relatedTo="object_c", relatedvia="pivottwo" } };
				var object_b_props = { as={ name="as", relationship="many-to-many", relatedTo="object_a", relatedvia="object_d" } };
				var object_c_props = { as={ name="as", relationship="many-to-many", relatedTo="object_a", relatedvia="pivottwo" } };
				var object_d_props = {};
				var mockFw         = getMockbox().createStub();
				var compiler       = new presidedataobjects.library.ObjectCompiler( framework=mockFw );

				objects.object_a.$( "getProperties", object_a_props );
				objects.object_b.$( "getProperties", object_b_props );
				objects.object_c.$( "getProperties", object_c_props );
				objects.object_d.$( "getProperties", object_d_props );

				helper.createAutoPivotObjects( objects=objects, compiler=compiler );

  				expect( objects.keyArray().sort( "textnocase" ) ).toBe( [ "nonexistantpivot", "object_a", "object_b", "object_c", "object_d", "pivottwo" ] );

			} );

		} );
	}

}