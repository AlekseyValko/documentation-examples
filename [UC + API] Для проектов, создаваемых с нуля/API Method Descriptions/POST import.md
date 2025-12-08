# POST import

---

| Наименование | Import Kaiten structure                                        |
|:------------ | -------------------------------------------------------------- |
| **Описание** | Метод необходим для импорта структуры пользовательского Kaiten |

| baseUrl      |
|:------------ |
| base.url.com |

| Метод                         | POST                                 |
|:----------------------------- | ------------------------------------ |
| **URL**                       | https://baseURL/api/v1/kaiten/import |
| **Тип интерфейса / протокол** | API / HTTPS                          |

| Query Params | Описание |
|:------------ | -------- |
| -            | -        |

> Пример тел запроса/ответа ниже, так как markdown плохо переваривает сноски кода в таблицах.

| Тело запроса            | Тело ответа            |
|:----------------------- | ---------------------- |
|                         |                        |
| **Пример тела запроса** | **Пример тела ответа** |
|                         |                        |

---

### Тело запроса

```json
{ 
    "role": "string (enum)",
    "url": "string",
    "token": "string",
    "include_archive": "boolean"
}
```

### Тело ответа

```json
{
    "loaded": "boolean",
    "with_archive": "boolean",
    "spaces": [
        {
            "id": "number",
            "uid": "string",
            "title": "string",
            "boards": [
                {
                    "id": "number",
                    "title": "string",
                    "columns": [
                        {
                            "id": "number",
                            "title": "string",
                            "cards": [
                                {
                                    "id": "number",
                                    "title": "string"
                                }
                            ]
                        }
                    ]
                }
            ],
            "subspaces": [
                {
                    "id": "number",
                    "uid": "string",
                    "title": "string",
                    "boards": [
                    ],
                    "subspaces": [
                    ]
                }
            ]
        }
    ],
    "archive": [
        {
            "spaces": [
                {
                    "id": "number",
                    "uid": "string",
                    "title": "string",
                    "boards": [
                        {
                            "id": "number",
                            "title": "string",
                            "columns": [
                                {
                                    "id": "number",
                                    "title": "string",
                                    "cards": [
                                        {
                                            "id": "number",
                                            "title": "string"
                                        }
                                    ]
                                }
                            ]
                        }
                    ],
                    "subspaces": [
                        {
                            "id": "number",
                            "uid": "string",
                            "title": "string",
                            "boards": [],
                            "subspaces": []
                        }
                    ]
                }
            ]
        }
    ]
}
```

---

### Пример тела запроса

```json
{
    "role": "1",
    "url": "https://example.kaiten.ru",
    "token": "14887312-d876-4ea5-afb945e3e7a63715",
    "include_archive": false
}
```

### Пример тела ответа

```json
{
    "loaded": true,
    "with_archive": false,
    "spaces": [
        {
            "id": 687238,
            "uid": "18649b4c-e722-4af1-87d8-da80d774900d",
            "title": "Test space 1",
            "boards": [
                {
                    "id": 1569427,
                    "title": "Board",
                    "columns": [
                        {
                            "id": 5444258,
                            "title": "Backlog",
                            "cards": []
                        },
                        {
                            "id": 5444259,
                            "title": "In work",
                            "cards": []
                        },
                        {
                            "id": 5444260,
                            "title": "Done",
                            "cards": [
                                {
                                    "id": 58148363,
                                    "title": "Card 1"
                                }
                            ]
                        }
                    ]
                }
            ],
            "subspaces": [
                {
                    "id": 692451,
                    "uid": "c20fbf97-3872-4d39-8649eed3de2913e7",
                    "title": "test_subspace_in",
                    "boards": [],
                    "subspaces": []
                }
            ]
        }
    ],
    "archive": []
}
```

---
