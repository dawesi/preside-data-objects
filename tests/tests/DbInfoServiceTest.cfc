component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		variables.testDsn = "anyolddsn";
	}

	// executes after all suites+specs in the run() method
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){
		describe( "getDatabaseVersion()", function(){
			it( "should return result from dbinfo type='version' call ", function(){
				var service     = _getInfoService();
				var dummyResult = QueryNew( 'test', 'varchar', [[ CreateUUId() ]] );

				service.$( "_dbInfo" ).$args( datasource=testDsn, type="version" ).$results( dummyResult );

				expect( service.getDatabaseVersion( dsn=testDsn ) ).toBe( dummyResult );
			} );
		} );

		describe( "listTables", function(){
			it( "should return result of call to dbinfo type='tables' converted to array of names", function(){
				var service        = _getInfoService();
				var dummyRecordset = QueryNew( "table_name", "varchar", [
					  [ "table_1"]
					, [ "table_2"]
					, [ "table_3"]
					, [ "table_4"]
					, [ "table_5"]
				] );
				var expected = [ "table_1", "table_2", "table_3", "table_4", "table_5" ];

				service.$( "_dbInfo" ).$args( datasource=testDsn, type="tables" ).$results( dummyRecordset );

				expect( service.listTables( dsn=testDsn ) ).toBe( expected );
			} );
		} );

		describe( "tableExists()", function(){
			it( "should return false when table is not found in list of tables from listTables()", function(){
				var service   = _getInfoService();
				var tablename = CreateUUId();

				service.$( "listTables" ).$args( dsn=testDsn ).$results( [ CreateUUId(), CreateUUId(), CreateUUId() ] );

				expect( service.tableExists( tablename=tablename, dsn=testDsn ) ).toBe( false );
			} );

			it( "should return true when table is found in list of tables from listTables()", function(){
				var service   = _getInfoService();
				var tablename = CreateUUId();

				service.$( "listTables" ).$args( dsn=testDsn ).$results( [ CreateUUId(), tablename, CreateUUId() ] );

				expect( service.tableExists( tablename=tablename, dsn=testDsn ) ).toBe( true );
			} );

		} );

		describe( "getTableInfo()", function(){
			it( "should return result of call to dbinfo type='tables' filtered by the passed tablename", function(){
				var service     = _getInfoService();
				var dummyResult = QueryNew( 'test', 'varchar', [[ CreateUUId() ]] );
				var tableName   = CreateUUId();

				service.$( "_dbInfo" ).$args( datasource=testDsn, type="tables", pattern=tableName ).$results( dummyResult );

				expect( service.getTableInfo( dsn=testDsn, tableName=tableName ) ).toBe( dummyResult );
			} );
		} );

		describe( "getTableColumns()", function(){
			it( "should return result of call to dbinfo type='columns' filtered by the passed tablename", function(){
				var service     = _getInfoService();
				var dummyResult = QueryNew( 'test', 'varchar', [[ CreateUUId() ]] );
				var tableName   = CreateUUId();

				service.$( "_dbInfo" ).$args( datasource=testDsn, type="columns", table=tableName ).$results( dummyResult );

				expect( service.getTableColumns( dsn=testDsn, tableName=tableName ) ).toBe( dummyResult );
			} );
		} );

		describe( "getTableIndexes", function(){
			it( "should return result of call to dbinfo type='index' filtered by the passed tablename, reformatted into a useful structure and excluding the primary key", function(){
				var service     = _getInfoService();
				var tableName   = CreateUUId();
				var dummyResult = QueryNew( 'non_unique,index_name,column_name', 'varchar,varchar,varchar', [
					  [ "false", "PRIMARY" , "id" ]
					, [ "false", "ux_one"  , "fielda" ]
					, [ "false", "ux_one"  , "fieldb" ]
					, [ "true" , "ix_two"  , "fielda" ]
					, [ "true" , "ix_two"  , "fieldb" ]
					, [ "true" , "ix_two"  , "fieldc" ]
					, [ "true" , "ix_three", "fielda" ]
				] );
				var expectedConversion = {
					  ux_one   = { unique=true , fields=[ "fielda", "fieldb" ] }
					, ix_two   = { unique=false, fields=[ "fielda", "fieldb", "fieldc" ] }
					, ix_three = { unique=false, fields=[ "fielda" ] }
				};

				service.$( "_dbInfo" ).$args( datasource=testDsn, type="index", table=tableName ).$results( dummyResult );

				expect( service.getTableIndexes( dsn=testDsn, tableName=tableName ) ).toBe( expectedConversion );
			} );
		} );

		describe( "getTableForeignKeys", function(){
			it( "should return result of call to dbinfo type='foreignKeys' filtered by the passed tablename, reformatted into a useful structure", function(){
				var service     = _getInfoService();
				var tableName   = CreateUUId();
				var dummyResult = QueryNew( 'fk_name,pktable_name,pkcolumn_name,fktable_name,fkcolumn_name,update_rule,delete_rule', 'varchar,varchar,varchar,varchar,varchar,varchar,varchar', [
					  [ "fk_key1", "tablea", "fielda", "tableb", "fieldc", "0", "0" ]
					, [ "fk_key2", "tablea", "fieldb", "tablec", "fieldd", "2", "1" ]
					, [ "fk_key3", "tableb", "fieldx", "tableb", "fieldc", "1", "1" ]
					, [ "fk_key4", "tableb", "fieldy", "tablea", "fieldx", "2", "2" ]
				] );
				var expectedConversion = {
					  fk_key1 = { pk_table="tablea", fk_table="tableb", pk_column="fielda", fk_column="fieldc", on_update="cascade" , on_delete="cascade"  }
					, fk_key2 = { pk_table="tablea", fk_table="tablec", pk_column="fieldb", fk_column="fieldd", on_update="set null", on_delete="error"    }
					, fk_key3 = { pk_table="tableb", fk_table="tableb", pk_column="fieldx", fk_column="fieldc", on_update="error"   , on_delete="error"    }
					, fk_key4 = { pk_table="tableb", fk_table="tablea", pk_column="fieldy", fk_column="fieldx", on_update="set null", on_delete="set null" }
				};

				service.$( "_dbInfo" ).$args( datasource=testDsn, type="foreignKeys", table=tableName ).$results( dummyResult );

				expect( service.getTableForeignKeys( dsn=testDsn, tableName=tableName ) ).toBe( expectedConversion );
			} );
		} );
	}


/*********************************** PRIVATE HELPERS ***********************************/
	private any function _getInfoService() {
		var service = new presidedataobjects.db.DbInfoService();

		return getMockbox().createMock( object=service );
	}

}