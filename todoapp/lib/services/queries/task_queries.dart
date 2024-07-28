const String getTasksQuery = r'''
  query GetTasks($userId: ID) {
    tasks(filters: { user: { id: { eq: $userId } } }) {
      data {
        id
        attributes {
          title
          description
          completed
        }
      }
    }
  }
''';

const String updateTaskMutation = r'''
  mutation UpdateTask($id: ID!, $completed: Boolean!) {
    updateTask(id: $id, data: { completed: $completed }) {
      data {
        id
        attributes {
          title
          description
          completed
        }
      }
    }
  }
''';

const String deleteTaskMutation = r'''
  mutation DeleteTask($id: ID!) {
    deleteTask(id: $id) {
      data {
        id
      }
    }
  }
''';

const String updateCompleteTaskMutation = r'''
  mutation UpdateTask($id: ID!, $title: String!, $description: String!, $completed: Boolean!) {
    updateTask(id: $id, data: { title: $title, description: $description, completed: $completed }) {
      data {
        id
      }
    }
  }
''';

const String createTaskMutation = r'''
  mutation CreateTask($title: String!, $description: String!, $completed: Boolean!, $publishedAt: DateTime!, $userId: ID!) {
    createTask(data: { 
      title: $title, 
      description: $description, 
      completed: $completed, 
      publishedAt: $publishedAt,
      user: $userId  
    }) {
      data {
        id
      }
    }
  }
''';
