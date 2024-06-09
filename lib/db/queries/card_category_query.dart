const createCardCategoryTable = '''
        CREATE TABLE card_category (
          id TEXT PRIMARY KEY,
          name TEXT,
          icon TEXT,
          dark_icon TEXT
        );
''';