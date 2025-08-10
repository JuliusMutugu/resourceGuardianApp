import axios, { AxiosInstance, AxiosResponse } from 'axios';
import { API_CONFIG } from '../styles/constants';
import { 
  AuthRequest, 
  AuthResponse, 
  RegisterRequest, 
  User, 
  Transaction, 
  SavingsGoal, 
  Goal,
  DashboardData 
} from '../types';

class ApiService {
  private api: AxiosInstance;
  private token: string | null = null;

  constructor() {
    this.api = axios.create({
      baseURL: API_CONFIG.BASE_URL,
      timeout: API_CONFIG.TIMEOUT,
      headers: {
        'Content-Type': 'application/json',
      },
    });

    // Request interceptor to add auth token
    this.api.interceptors.request.use((config) => {
      if (this.token) {
        config.headers.Authorization = `Bearer ${this.token}`;
      }
      return config;
    });

    // Response interceptor for error handling
    this.api.interceptors.response.use(
      (response) => response,
      (error) => {
        if (error.response?.status === 401) {
          this.clearToken();
          // Navigate to login screen
        }
        return Promise.reject(error);
      }
    );
  }

  setToken(token: string) {
    this.token = token;
  }

  clearToken() {
    this.token = null;
  }

  // Auth endpoints
  async login(credentials: AuthRequest): Promise<AuthResponse> {
    const response: AxiosResponse<AuthResponse> = await this.api.post('/auth/login', credentials);
    this.setToken(response.data.token);
    return response.data;
  }

  async register(userData: RegisterRequest): Promise<AuthResponse> {
    const response: AxiosResponse<AuthResponse> = await this.api.post('/auth/register', userData);
    this.setToken(response.data.token);
    return response.data;
  }

  async logout(): Promise<void> {
    await this.api.post('/auth/logout');
    this.clearToken();
  }

  // User endpoints
  async getCurrentUser(): Promise<User> {
    const response: AxiosResponse<User> = await this.api.get('/user/me');
    return response.data;
  }

  async updateUser(userData: Partial<User>): Promise<User> {
    const response: AxiosResponse<User> = await this.api.put('/user/me', userData);
    return response.data;
  }

  // Dashboard endpoint
  async getDashboardData(): Promise<DashboardData> {
    const response: AxiosResponse<DashboardData> = await this.api.get('/dashboard');
    return response.data;
  }

  // Transaction endpoints
  async getTransactions(page: number = 0, size: number = 20): Promise<Transaction[]> {
    const response: AxiosResponse<Transaction[]> = await this.api.get(
      `/transactions?page=${page}&size=${size}`
    );
    return response.data;
  }

  async getTransactionById(id: string): Promise<Transaction> {
    const response: AxiosResponse<Transaction> = await this.api.get(`/transactions/${id}`);
    return response.data;
  }

  async createTransaction(transaction: Omit<Transaction, 'id' | 'userId'>): Promise<Transaction> {
    const response: AxiosResponse<Transaction> = await this.api.post('/transactions', transaction);
    return response.data;
  }

  async updateTransaction(id: string, transaction: Partial<Transaction>): Promise<Transaction> {
    const response: AxiosResponse<Transaction> = await this.api.put(`/transactions/${id}`, transaction);
    return response.data;
  }

  async deleteTransaction(id: string): Promise<void> {
    await this.api.delete(`/transactions/${id}`);
  }

  // Savings Goal endpoints
  async getSavingsGoals(): Promise<SavingsGoal[]> {
    const response: AxiosResponse<SavingsGoal[]> = await this.api.get('/savings-goals');
    return response.data;
  }

  async getSavingsGoalById(id: string): Promise<SavingsGoal> {
    const response: AxiosResponse<SavingsGoal> = await this.api.get(`/savings-goals/${id}`);
    return response.data;
  }

  async createSavingsGoal(goal: Omit<SavingsGoal, 'id' | 'userId'>): Promise<SavingsGoal> {
    const response: AxiosResponse<SavingsGoal> = await this.api.post('/savings-goals', goal);
    return response.data;
  }

  async updateSavingsGoal(id: string, goal: Partial<SavingsGoal>): Promise<SavingsGoal> {
    const response: AxiosResponse<SavingsGoal> = await this.api.put(`/savings-goals/${id}`, goal);
    return response.data;
  }

  async deleteSavingsGoal(id: string): Promise<void> {
    await this.api.delete(`/savings-goals/${id}`);
  }

  // Goal endpoints
  async getGoals(): Promise<Goal[]> {
    const response: AxiosResponse<Goal[]> = await this.api.get('/goals');
    return response.data;
  }

  async getGoalById(id: string): Promise<Goal> {
    const response: AxiosResponse<Goal> = await this.api.get(`/goals/${id}`);
    return response.data;
  }

  async createGoal(goal: Omit<Goal, 'id' | 'userId'>): Promise<Goal> {
    const response: AxiosResponse<Goal> = await this.api.post('/goals', goal);
    return response.data;
  }

  async updateGoal(id: string, goal: Partial<Goal>): Promise<Goal> {
    const response: AxiosResponse<Goal> = await this.api.put(`/goals/${id}`, goal);
    return response.data;
  }

  async deleteGoal(id: string): Promise<void> {
    await this.api.delete(`/goals/${id}`);
  }
}

export const apiService = new ApiService();
export default apiService;
