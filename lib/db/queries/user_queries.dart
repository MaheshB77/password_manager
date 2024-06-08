const createUserTable = '''
        CREATE TABLE user (
          id TEXT PRIMARY KEY,
          master_password TEXT NOT NULL,
          createdAt TEXT,
          updatedAt TEXT
        );
    ''';

const updateUserTable1 = '''
        ALTER TABLE user 
        ADD COLUMN fingerprint INTEGER DEFAULT 1;
    ''';

const updateUserTable2 = '''
        ALTER TABLE user 
        ADD COLUMN theme TEXT DEFAULT 'system';
    ''';
