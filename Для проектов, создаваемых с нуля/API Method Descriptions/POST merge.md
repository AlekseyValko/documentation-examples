# POST merge

---

| Наименование | Merge new structure with target Kaiten                                                                                           |
|:------------ | -------------------------------------------------------------------------------------------------------------------------------- |
| **Описание** | Метод необходим для передачи атрибутов Kaiten-источника в backend приложения для загрузки переданных атрибутов в целевой Kaiten. |

| baseUrl      |
|:------------ |
| base.url.com |

| Метод                         | POST                                |
|:----------------------------- | ----------------------------------- |
| **URL**                       | https://baseURL/api/v1/kaiten/merge |
| **Тип интерфейса / протокол** | API / HTTPS                         |

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
    "with_archive": "boolean",
    "source_to_target": {
        "spaces": [
            {
                "source_space_id": "number",
                "source_space_title": "string",
                "target_space_id": "number",
                "boards": [
                    {
                        "source_board_id": "number",
                        "source_board_title": "string",
                        "target_board_id": "number",
                        "columns": [
                            {
                                "source_column_id": "number",
                                "source_column_title": "string",
                                "target_board_id": "number",
                                "cards": [
                                    {
                                        "source_card_id": "number",
                                        "source_card_title": "string",
                                        "target_board_id": "number",
                                        "target_column_id": "number"
                                    }
                                ]
                            }
                        ]
                    }
                ]
            }
        ]
    },
    "archive": [
        {
            "source_to_target": {
                "spaces": [
                    {
                        "source_space_id": "number",
                        "source_space_title": "string",
                        "target_space_id": "number",
                        "boards": [
                            {
                                "source_board_id": "number",
                                "source_board_title": "string",
                                "target_board_id": "number",
                                "columns": [
                                    {
                                        "source_column_id": "number",
                                        "source_column_title": "string",
                                        "target_board_id": "number",
                                        "cards": [
                                            {
                                                "source_card_id": "number",
                                                "source_card_title": "string",
                                                "target_board_id": "number",
                                                "target_column_id": "number"
                                            }
                                        ]
                                    }
                                ]
                            }
                        ]
                    }
                ]
            }
        }
    ]
}
```

### Тело ответа

200 OK

400 Bad Request

500 Internal Server Error

---

### Пример тела запроса

```json
{
    "with_archive": false,
    "source_to_target": {
        "spaces": [
            {
                "source_space_id": 691880,
                "source_space_title": "Space for test",
                "target_space_id": 000000,
                "boards": [
                    {
                        "source_board_id": 1568175,
                        "source_board_title": "Sprint",
                        "target_board_id": 000000,
                        "columns": [
                            {
                                "source_column_id": 5440063,
                                "source_column_title": "Sprint Backlog",
                                "target_board_id": 000000,
                                "cards": [
                                    {
                                        "source_card_id": 57923165,
                                        "source_card_title": "Card 1",
                                        "target_board_id": 000000,
                                        "target_column_id": 000000
                                    }
                                ]
                            }
                        ]
                    }
                ]
            }
        ]
    },
    "archive": []
}
```

### Пример тела ответа

200 OK

400 Bad Request

500 Internal Server Error

---
