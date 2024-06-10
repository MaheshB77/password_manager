const createUserTable = '''
        CREATE TABLE user (
          id TEXT PRIMARY KEY,
          master_password TEXT NOT NULL,
          fingerprint INTEGER DEFAULT 0,
          theme TEXT DEFAULT 'system',
          createdAt TEXT,
          updatedAt TEXT
        );
    ''';

const updateUserTable1 = '''
        ALTER TABLE user ADD COLUMN password_hint TEXT;
    ''';