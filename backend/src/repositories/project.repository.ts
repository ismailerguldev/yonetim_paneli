import connection from "../config/mysql.config.js";
import type { IProject, ITask } from "../models/project.model.js";
import type { ResultSetHeader, RowDataPacket } from "mysql2";
export interface Project extends RowDataPacket {
    id: string
    name: string
    end_date: string
    priority: string
    progress: number
}
export interface ProjectDetail extends RowDataPacket {
    description: string
    taskId: string
    taskDescription: string
    taskIsDone: number
    progress: number
}
const createProject = async (project: IProject, userId: string) => {
    const query = "INSERT INTO projects (id,name,description,end_date,priority,user_id) VALUES (UUID_TO_BIN(?),?,?,?,?,UUID_TO_BIN(?))"
    try {
        const [result] = await connection.execute<ResultSetHeader>(query, [project.id, project.name, project.description, new Date(project.end_date), project.priority, userId])
        return result.affectedRows === 1;
    } catch (e) {
        throw e;
    }
}
const getProjects = async (userId: string) => {
    const query = "SELECT BIN_TO_UUID(id) as id, name, end_date as endDate, priority, progress FROM projects WHERE user_id = UUID_TO_BIN(?) AND is_active = 1 ORDER BY end_date"
    try {
        const [result] = await connection.execute<Project[]>(query, [userId]);
        return result
    } catch (e) {
        throw e
    }
}
const getProjectDetail = async (projectId: string) => {
    const query = "SELECT projects.description as description, BIN_TO_UUID(tasks.id) as taskId, projects.progress as progress, tasks.description as taskDescription, tasks.is_done as taskIsDone FROM projects LEFT JOIN tasks ON projects.id = tasks.project_id WHERE projects.id = UUID_TO_BIN(?)"
    try {
        const [result] = await connection.execute<ProjectDetail[]>(query, [projectId])
        return result
    } catch (e) {
        throw e
    }
}
const removeProject = async (projectId: string, userId: string) => {
    const query = "UPDATE projects SET is_active = 0 WHERE id = UUID_TO_BIN(?) AND user_id = UUID_TO_BIN(?)"
    try {
        const [result] = await connection.execute<ResultSetHeader>(query, [projectId, userId]);
        return result.affectedRows === 1
    } catch (e) {
        throw e
    }
}
const createProjectTask = async (task: ITask) => {
    const query = "INSERT INTO tasks (id,description,project_id) VALUES (UUID_TO_BIN(?),?,UUID_TO_BIN(?))"
    try {
        const [result] = await connection.execute<ResultSetHeader>(query, [task.id!, task.description, task.project_id!])
        return result.affectedRows === 1
    } catch (e) {
        throw e
    }
}
const updateProjectTask = async (taskId: string, value: number) => {
    const query = "UPDATE tasks SET is_done = ? WHERE id = UUID_TO_BIN(?)"
    try {
        const [result] = await connection.execute<ResultSetHeader>(query, [value, taskId])
        return result.affectedRows === 1
    } catch (e) {
        throw e
    }
}
const deleteProjectTask = async (taskId: string) => {
    const query = "DELETE FROM tasks WHERE id = UUID_TO_BIN(?)"
    try {
        const [result] = await connection.execute<ResultSetHeader>(query, [taskId])
        return result.affectedRows === 1
    } catch (e) {
        throw e
    }
}
export default {
    createProject,
    getProjects,
    getProjectDetail,
    createProjectTask,
    updateProjectTask,
    deleteProjectTask,
    removeProject
}