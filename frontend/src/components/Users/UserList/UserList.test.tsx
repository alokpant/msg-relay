import { render, screen, act } from '@testing-library/react';
import UserList from './UserList';
import fetch from 'jest-fetch-mock';

describe('UserList Component', () => {
  const MOCK_USERS = [
    {
      "id": 1,
      "email": "test@example.com",
      "json_web_token": "5ea3fc72c731549443270280cc1e7472",
      "created_at":"2024-06-03T07:57:47.716Z", "updated_at":"2024-06-03T07:57:47.716Z"
    },
    {
      "id": 2,
      "email": "test1@example.com",
      "json_web_token": "114d000755ef738fd219c89c15afc444",
      "created_at": "2024-06-03T07:57:52.489Z",
      "updated_at": "2024-06-03T07:57:52.489Z"
    },
    { 
      "id": 3,
      "email": "test2@example.com",
      "json_web_token": "45ac30eba8b8ef7f1cfb39f086ba8757",
      "created_at": "2024-06-03T07:57:56.102Z",
      "updated_at": "2024-06-03T07:57:56.102Z"
    },
    {
      "id":4, 
      "email": "newuser_0@example.com",
      "json_web_token": "2e4cc65ffff7adbdf392cc44214fece8",
      "created_at":"2024-06-03T09:17:10.131Z",
      "updated_at":"2024-06-03T09:17:10.131Z"
    }]

  beforeEach(() => {
    fetch.resetMocks();
  })

  it('renders all items correctly', async () => {
    fetch.mockResponseOnce(JSON.stringify(MOCK_USERS));

    await act(() => render(<UserList />));

    expect(screen.getByText(/test@example.com/)).toBeInTheDocument();
    expect(screen.getByText(/newuser_0@example.com/)).toBeInTheDocument();
    expect(fetch).toHaveBeenCalledTimes(1)
  });
});

