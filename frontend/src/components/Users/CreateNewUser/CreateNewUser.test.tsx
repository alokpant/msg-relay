import { render, screen, fireEvent, waitForElementToBeRemoved } from '@testing-library/react';
import userEvent from '@testing-library/user-event'
import CreateNewUser from './CreateNewUser';
import fetch from 'jest-fetch-mock';

describe('CreateNewUser Component', () => {
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

    const TEST_IDS = {
      add_new_user: 'button-add-new-user',
      email: 'input-email',
      create: 'button-create-user',
      cancel: 'button-cancel-user'
    }

    const LABELS = {
      add_new_user: /Add new user/,
      create_new_user: /Create new user/,
    }

  beforeEach(() => {
    fetch.resetMocks();
  })

  it('renders all items correctly', () => {
    fetch.mockResponseOnce(JSON.stringify(MOCK_USERS));

    render(<CreateNewUser setRefetchUsers={() => jest.fn() } />);
    expect(screen.getByText(LABELS.add_new_user)).toBeInTheDocument();
  });

  it('loads create new user dialog when Add new user button is clicked', () => {
    fetch.mockResponseOnce(JSON.stringify(MOCK_USERS));

    render(<CreateNewUser setRefetchUsers={() => jest.fn() } />);
    expect(screen.getByTestId(TEST_IDS.add_new_user)).toBeTruthy();

    fireEvent.click(screen.getByTestId(TEST_IDS.add_new_user));
    expect(screen.getByText(LABELS.create_new_user)).toBeInTheDocument();
    expect(screen.getByTestId(TEST_IDS.email)).toBeTruthy();
    expect(screen.getByTestId(TEST_IDS.create)).toBeTruthy();
    expect(screen.getByTestId(TEST_IDS.cancel)).toBeTruthy();
  });

  describe('Create new user dialog', () => {
    it('closes the dialog when cancel button is clicked', async () => {
      fetch.mockResponseOnce(JSON.stringify(MOCK_USERS));
  
      const { queryByText } = render(<CreateNewUser setRefetchUsers={() => jest.fn() } />);
      expect(queryByText(LABELS.add_new_user)).toBeInTheDocument();
      fireEvent.click(screen.getByTestId(TEST_IDS.add_new_user));
  
      expect(queryByText(LABELS.create_new_user)).toBeInTheDocument();
      expect(screen.getByTestId(TEST_IDS.cancel)).toBeTruthy();

      fireEvent.click(screen.getByTestId(TEST_IDS.cancel));
      await waitForElementToBeRemoved(() => queryByText(LABELS.create_new_user));
      expect(queryByText(LABELS.create_new_user)).toBeNull();
      expect(fetch).not.toHaveBeenCalledTimes(0);
    });

    it('sends a request when create button is clicked', async () => {
      const user = userEvent.setup()
      fetch.mockResponseOnce(JSON.stringify(MOCK_USERS));
  
      const { queryByText } = render(<CreateNewUser setRefetchUsers={() => jest.fn() } />);
      expect(queryByText(LABELS.add_new_user)).toBeInTheDocument();
      fireEvent.click(screen.getByTestId(TEST_IDS.add_new_user));
  
      expect(queryByText(LABELS.create_new_user)).toBeInTheDocument();
      expect(screen.getByTestId(TEST_IDS.create)).toBeTruthy();

      const emailInput = screen.getByTestId(TEST_IDS.email)
      const MOCK_EMAIL = 'example@test.com';
      expect(emailInput.getAttribute('value')).toBe('')

      await user.type(emailInput, MOCK_EMAIL)
      fireEvent.click(screen.getByTestId(TEST_IDS.create));
      await waitForElementToBeRemoved(() => queryByText(LABELS.create_new_user));
      expect(queryByText(LABELS.create_new_user)).toBeNull();
      expect(fetch).toHaveBeenCalledTimes(1);
    });
  });
});

