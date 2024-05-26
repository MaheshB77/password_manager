const createUserTable = '''
        CREATE TABLE user (
          id TEXT PRIMARY KEY,
          master_password TEXT NOT NULL,
          createdAt TEXT,
          updatedAt TEXT
        );
    ''';
