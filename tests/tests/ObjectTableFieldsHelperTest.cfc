component extends="testbox.system.BaseSpec"{

	function beforeAll(){}
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){
		helper = new presidedataobjects.db.helpers.ObjectTableFieldsHelper();

		describe( "listTableFields()", function(){
			it( "should list all the names of properties in an object that map directly to a database field, ignoring relational indicators, etc", function(){
				var myObj = getMockbox().createStub();

				myObj.$( "getName", "testme" );
				myObj.$( "getProperties", {
					  label       = { name="label"  , dbtype="varchar" }
					, mystery     = { name="mystery", dbtype="none"    }
					, m2m         = { name="m2m"    , relationship="many-to-many"    }
					, one2m       = { name="one2m"  , relationship="many-to-many"    }
					, datecreated = { name="datecreated", type="date", dbtype="date" }
				} );


				var fields = helper.listTableFields( myObj );

				expect( fields.sort( "textnocase" ) ).toBe( [ "datecreated", "label" ] );

			} );
		} );
	}

}