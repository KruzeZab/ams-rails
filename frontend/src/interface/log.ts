type ActionType = 'create' | 'update' | 'delete';

export enum ActionLog {
  CREATE = 'create',
  UPDATE = 'update',
  DELETE = 'delete',
}

interface UserSummary {
  id: number;
  email: string;
}

type Primitive = string | number | boolean | null;

type ChangeLogCreateOrDelete = Record<string, Primitive>;
type ChangeLogUpdate = Record<string, [Primitive, Primitive]>;

interface BaseActivityLog {
  id: number;
  action: ActionType;
  recordType: string;
  recordId: number;
  createdAt: string;
  user?: UserSummary;
}

interface CreateLog extends BaseActivityLog {
  action: 'create';
  changeLog: ChangeLogCreateOrDelete;
}

interface UpdateLog extends BaseActivityLog {
  action: 'update';
  changeLog: ChangeLogUpdate;
}

interface DeleteLog extends BaseActivityLog {
  action: 'delete';
  changeLog: ChangeLogCreateOrDelete;
}

export type ActivityLog = CreateLog | UpdateLog | DeleteLog;
