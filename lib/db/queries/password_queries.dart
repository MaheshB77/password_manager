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
