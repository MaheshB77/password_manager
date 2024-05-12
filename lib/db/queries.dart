const createPasswordTable = '''
        CREATE TABLE passwords (
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          username TEXT NOT NULL,
          password TEXT NOT NULL,
          categoryId TEXT NOT NULL,
          email TEXT,
          note TEXT,
          iconId TEXT,
          createdAt TEXT,
          updatedAt TEXT
        );
      ''';

const createCategoriesTable = '''
        CREATE TABLE categories (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL
        );
    ''';

const createUserTable = '''
        CREATE TABLE user (
          id TEXT PRIMARY KEY,
          master_password TEXT NOT NULL,
          createdAt TEXT,
          updatedAt TEXT
        );
    ''';