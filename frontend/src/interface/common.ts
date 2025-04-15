export interface OptionType<T> {
  name: string;
  code: T;
}

export interface Meta {
  currentPage: number;
  totalPages: number;
  totalCount: number;
}
