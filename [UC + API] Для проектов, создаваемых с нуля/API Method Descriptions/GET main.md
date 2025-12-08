# GET /main

---

| Наименование | Get main page                                         |
|:------------ | ----------------------------------------------------- |
| **Описание** | Метод необходим для получения HTML основной страницы. |

| baseUrl      |
|:------------ |
| base.url.com |

| Метод                         | GET                         |
|:----------------------------- | --------------------------- |
| **URL**                       | https://baseURL/api/v1/main |
| **Тип интерфейса / протокол** | API / HTTPS                 |

| Query Params | Описание |
|:------------ | -------- |
| -            | -        |

| Тело запроса            | Тело ответа                                                                          |
|:----------------------- | ------------------------------------------------------------------------------------ |
| -                       | HTML код основной страницы                                                           |
| **Пример тела запроса** | **Пример тела ответа**                                                               |
| -                       | Пример тела ответа ниже, так как markdown плохо переваривает сноски кода в таблицах. |

---

### Пример тела ответа для метода GET /main

```html
<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8" />
  <title>Kaiten Migration MVP</title>
  <style>
    * {
      box-sizing: border-box;
    }

    body {
      margin: 0;
      font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      background: #f5f5f7;
      color: #222;
      height: 100vh;
      display: flex;
      flex-direction: column;
    }

    header {
      padding: 12px 20px;
      background: #1f2933;
      color: #fff;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }

    header h1 {
      margin: 0;
      font-size: 18px;
      font-weight: 600;
    }

    header .subtitle {
      font-size: 13px;
      opacity: 0.8;
    }

    main {
      flex: 1;
      display: flex;
      gap: 12px;
      padding: 12px;
    }

    .pane {
      flex: 1;
      background: #fff;
      border-radius: 10px;
      box-shadow: 0 1px 4px rgba(15, 23, 42, 0.08);
      display: flex;
      flex-direction: column;
      min-width: 0;
    }

    .pane-header {
      padding: 10px 12px;
      border-bottom: 1px solid #e5e7eb;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }

    .pane-title {
      font-size: 14px;
      font-weight: 600;
    }

    .pane-subtitle {
      font-size: 11px;
      color: #6b7280;
    }

    .tree-container {
      flex: 1;
      overflow: auto;
      padding: 8px 10px 10px;
    }

    .tree-root {
      list-style: none;
      margin: 0;
      padding-left: 0;
    }

    .tree-node {
      list-style: none;
      margin: 2px 0;
      padding-left: 16px;
      position: relative;
    }

    .tree-node::before {
      content: "";
      position: absolute;
      left: 6px;
      top: 0;
      bottom: 0;
      width: 1px;
      background: #e5e7eb;
    }

    .tree-node > .node-content {
      display: inline-flex;
      align-items: center;
      gap: 4px;
      padding: 3px 6px;
      border-radius: 6px;
      cursor: grab;
      font-size: 13px;
      background: #f9fafb;
      border: 1px solid transparent;
      position: relative;
      z-index: 1;
    }

    .tree-node > .node-content:active {
      cursor: grabbing;
    }

    .node-content .toggle {
      width: 14px;
      height: 14px;
      border-radius: 999px;
      font-size: 10px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      border: 1px solid #d1d5db;
      background: #fff;
      user-select: none;
      cursor: pointer;
    }

    .node-content .label {
      white-space: nowrap;
    }

    .node-content .badge {
      font-size: 10px;
      padding: 1px 5px;
      border-radius: 999px;
      background: #e5e7eb;
      text-transform: uppercase;
      letter-spacing: 0.03em;
    }

    .tree-node[data-type="space"] > .node-content {
      background: #eef2ff;
      border-color: #e0e7ff;
    }

    .tree-node[data-type="board"] > .node-content {
      background: #ecfdf3;
      border-color: #bbf7d0;
    }

    .tree-node[data-type="status"] > .node-content {
      background: #fef9c3;
      border-color: #fde68a;
    }

    .tree-node[data-type="task"] > .node-content {
      background: #fee2e2;
      border-color: #fecaca;
    }

    .tree-node.collapsed > ul {
      display: none;
    }

    .tree-node.collapsed > .node-content .toggle {
      transform: rotate(-90deg);
    }

    .drop-target-highlight {
      outline: 2px dashed #6366f1;
      outline-offset: 2px;
      background: #eef2ff !important;
    }

    .placeholder {
      font-size: 12px;
      color: #9ca3af;
      font-style: italic;
    }

    footer {
      padding: 8px 12px;
      border-top: 1px solid #e5e7eb;
      background: #f9fafb;
      display: flex;
      align-items: center;
      gap: 8px;
    }

    footer button {
      padding: 6px 10px;
      border-radius: 6px;
      border: 1px solid #d1d5db;
      background: #111827;
      color: #fff;
      font-size: 12px;
      cursor: pointer;
    }

    footer button:hover {
      background: #111827ee;
    }

    footer .hint {
      font-size: 12px;
      color: #6b7280;
    }

    #result-json {
      white-space: pre;
      font-size: 11px;
      padding: 6px;
      margin: 0;
      background: #111827;
      color: #e5e7eb;
      border-radius: 6px;
      max-height: 140px;
      overflow: auto;
      flex: 1;
    }

    @media (max-width: 900px) {
      main {
        flex-direction: column;
      }
    }
  </style>
</head>
<body>
  <header>
    <div>
      <h1>Kaiten Migration MVP</h1>
      <div class="subtitle">
        Слева — исходный Kaiten, справа — целевая структура. Перетащи элементы для настройки миграции.
      </div>
    </div>
  </header>

  <main>
    <section class="pane">
      <div class="pane-header">
        <div>
          <div class="pane-title">Исходный Kaiten</div>
          <div class="pane-subtitle">Только чтение, можно перетаскивать в правую сторону (copy)</div>
        </div>
      </div>
      <div class="tree-container" id="left-pane">
        <ul class="tree-root" id="left-tree-root"></ul>
      </div>
    </section>

    <section class="pane">
      <div class="pane-header">
        <div>
          <div class="pane-title">Результат миграции</div>
          <div class="pane-subtitle">Можно перетаскивать из левой панели и внутри этой структуры</div>
        </div>
      </div>
      <div class="tree-container" id="right-pane">
        <div class="placeholder" id="right-placeholder">
          Перетащи сюда пространство, доску, статус или задачу из левой панели.
        </div>
        <ul class="tree-root" id="right-tree-root"></ul>
      </div>
    </section>
  </main>

  <footer>
    <button id="export-btn">Экспорт JSON результата</button>
    <div class="hint">JSON результата можно использовать для API-скрипта миграции.</div>
    <pre id="result-json"></pre>
  </footer>

  <script>
    // ----- Пример исходных данных Kaiten (MVP-хардкод) -----
    const sourceData = [
      {
        id: "space-1",
        type: "space",
        name: "Product Space",
        children: [
          {
            id: "board-1",
            type: "board",
            name: "Development Board",
            children: [
              {
                id: "status-1",
                type: "status",
                name: "Backlog",
                children: [
                  { id: "task-1", type: "task", name: "#1001 Login page" },
                  { id: "task-2", type: "task", name: "#1002 Signup flow" }
                ]
              },
              {
                id: "status-2",
                type: "status",
                name: "In Progress",
                children: [
                  { id: "task-3", type: "task", name: "#1003 Payment integration" }
                ]
              }
            ]
          },
          {
            id: "board-2",
            type: "board",
            name: "Support Board",
            children: [
              {
                id: "status-3",
                type: "status",
                name: "New",
                children: [
                  { id: "task-4", type: "task", name: "#2001 Client issue A" }
                ]
              }
            ]
          }
        ]
      },
      {
        id: "space-2",
        type: "space",
        name: "Marketing Space",
        children: [
          {
            id: "board-3",
            type: "board",
            name: "Campaigns",
            children: [
              {
                id: "status-4",
                type: "status",
                name: "Planned",
                children: [
                  { id: "task-5", type: "task", name: "#3001 Summer campaign" }
                ]
              }
            ]
          }
        ]
      }
    ];

    // ----- Рендер дерева -----
    function createTreeNode(node, side) {
      const li = document.createElement("li");
      li.className = "tree-node";
      li.dataset.id = node.id;
      li.dataset.type = node.type;
      li.dataset.side = side;

      const content = document.createElement("div");
      content.className = "node-content";
      content.draggable = true;

      const toggle = document.createElement("span");
      toggle.className = "toggle";
      toggle.textContent = "▾";

      const label = document.createElement("span");
      label.className = "label";
      label.textContent = node.name;

      const badge = document.createElement("span");
      badge.className = "badge";
      badge.textContent = node.type;

      content.appendChild(toggle);
      content.appendChild(label);
      content.appendChild(badge);
      li.appendChild(content);

      if (node.children && node.children.length > 0) {
        const ul = document.createElement("ul");
        node.children.forEach(child => {
          ul.appendChild(createTreeNode(child, side));
        });
        li.appendChild(ul);
      }

      attachNodeEvents(li, side);
      return li;
    }

    function renderTree(data, rootElement, side) {
      rootElement.innerHTML = "";
      const frag = document.createDocumentFragment();
      data.forEach(node => frag.appendChild(createTreeNode(node, side)));
      rootElement.appendChild(frag);
    }

    // ----- Drag & Drop -----
    let dragData = null;
    let currentDropHighlight = null;

    function attachNodeEvents(li, side) {
      const content = li.querySelector(":scope > .node-content");
      const toggle = content.querySelector(".toggle");

      // Если нет детей — убираем кнопку сворачивания
      if (!li.querySelector(":scope > ul")) {
        toggle.style.visibility = "hidden";
      }

      toggle.addEventListener("click", (e) => {
        e.stopPropagation();
        li.classList.toggle("collapsed");
      });

      content.addEventListener("dragstart", (e) => {
        dragData = {
          side,
          nodeId: li.dataset.id
        };
        e.dataTransfer.effectAllowed = side === "left" ? "copy" : "move";
        e.dataTransfer.setData("text/plain", JSON.stringify(dragData));
        setTimeout(() => {
          // небольшая прозрачность для источника
          content.style.opacity = "0.4";
        }, 0);
      });

      content.addEventListener("dragend", () => {
        content.style.opacity = "1";
        dragData = null;
        clearDropHighlight();
      });
    }

    function clearDropHighlight() {
      if (currentDropHighlight) {
        currentDropHighlight.classList.remove("drop-target-highlight");
        currentDropHighlight = null;
      }
    }

    function handleRightPaneDragOver(e) {
      e.preventDefault();
      if (!dragData) return;

      const node = e.target.closest(".tree-node");
      const rightPane = document.getElementById("right-pane");

      clearDropHighlight();

      if (node && rightPane.contains(node)) {
        const content = node.querySelector(":scope > .node-content");
        content.classList.add("drop-target-highlight");
        currentDropHighlight = content;
      } else {
        rightPane.classList.add("drop-target-highlight");
        currentDropHighlight = rightPane;
      }

      e.dataTransfer.dropEffect = "copy";
    }

    function handleRightPaneDrop(e) {
      e.preventDefault();
      if (!dragData) return;

      const rightPane = document.getElementById("right-pane");
      const rightRoot = document.getElementById("right-tree-root");
      const placeholder = document.getElementById("right-placeholder");

      clearDropHighlight();

      let fromSide;
      let nodeId;

      try {
        const parsed = JSON.parse(e.dataTransfer.getData("text/plain"));
        fromSide = parsed.side;
        nodeId = parsed.nodeId;
      } catch (err) {
        return;
      }

      const sourceNode = document.querySelector(
        `.tree-node[data-id="${CSS.escape(nodeId)}"][data-side="${fromSide}"]`
      );
      if (!sourceNode) return;

      let nodeToInsert;
      if (fromSide === "left") {
        // копируем из левой части
        nodeToInsert = sourceNode.cloneNode(true);
        updateSideOnSubtree(nodeToInsert, "right");
        reattachEventsOnSubtree(nodeToInsert, "right");
      } else {
        // переносим внутри правой структуры
        nodeToInsert = sourceNode;
      }

      // Определяем таргет в правой панели
      const targetNode = e.target.closest(".tree-node");
      if (targetNode && rightPane.contains(targetNode)) {
        const targetType = targetNode.dataset.type;

        // Если таргет — задача, вставляем на тот же уровень, а не как ребёнка
        if (targetType === "task") {
          const parentUl = targetNode.parentElement;
          parentUl.insertBefore(nodeToInsert, targetNode.nextSibling);
        } else {
          let childList = targetNode.querySelector(":scope > ul");
          if (!childList) {
            childList = document.createElement("ul");
            targetNode.appendChild(childList);
          }
          childList.appendChild(nodeToInsert);
        }
      } else {
        rightRoot.appendChild(nodeToInsert);
      }

      if (placeholder) {
        placeholder.remove();
      }
    }

    function updateSideOnSubtree(root, side) {
      if (root.classList && root.classList.contains("tree-node")) {
        root.dataset.side = side;
      }
      root.querySelectorAll(".tree-node").forEach(node => {
        node.dataset.side = side;
      });
    }

    function reattachEventsOnSubtree(root, side) {
      if (root.classList && root.classList.contains("tree-node")) {
        attachNodeEvents(root, side);
      }
      root.querySelectorAll(".tree-node").forEach(node => {
        attachNodeEvents(node, side);
      });
    }

    // ----- Экспорт результата в JSON -----
    function subtreeToData(li) {
      const node = {
        id: li.dataset.id,
        type: li.dataset.type,
        name: li.querySelector(":scope > .node-content .label").textContent.trim()
      };
      const childUl = li.querySelector(":scope > ul");
      if (childUl) {
        const children = [];
        childUl.querySelectorAll(":scope > .tree-node").forEach(childLi => {
          children.push(subtreeToData(childLi));
        });
        if (children.length > 0) {
          node.children = children;
        }
      }
      return node;
    }

    function exportResult() {
      const rightRoot = document.getElementById("right-tree-root");
      const result = [];
      rightRoot.querySelectorAll(":scope > .tree-node").forEach(li => {
        result.push(subtreeToData(li));
      });
      const pre = document.getElementById("result-json");
      pre.textContent = JSON.stringify(result, null, 2);
    }

    // ----- Инициализация -----
    document.addEventListener("DOMContentLoaded", () => {
      const leftRoot = document.getElementById("left-tree-root");
      renderTree(sourceData, leftRoot, "left");

      const rightPane = document.getElementById("right-pane");
      rightPane.addEventListener("dragover", handleRightPaneDragOver);
      rightPane.addEventListener("drop", handleRightPaneDrop);

      document.getElementById("export-btn").addEventListener("click", exportResult);
    });
  </script>
</body>
</html>
```

---
