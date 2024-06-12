import { render, screen, fireEvent, waitForElementToBeRemoved, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event'
import CreateNewUser from './CreateNewUser';
import fetch from 'jest-fetch-mock';

describe('CreateNewUser Component', () => {
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
    render(<CreateNewUser setRefetchUsers={() => jest.fn() } />);
    expect(screen.getByText(LABELS.add_new_user)).toBeInTheDocument();
  });

  it('loads create new user dialog when Add new user button is clicked', () => {
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
      const { queryByText } = render(<CreateNewUser setRefetchUsers={() => jest.fn() } />);
      expect(queryByText(LABELS.add_new_user)).toBeInTheDocument();
      fireEvent.click(screen.getByTestId(TEST_IDS.add_new_user));
  
      expect(queryByText(LABELS.create_new_user)).toBeInTheDocument();
      expect(screen.getByTestId(TEST_IDS.cancel)).toBeTruthy();

      fireEvent.click(screen.getByTestId(TEST_IDS.cancel));
      await waitForElementToBeRemoved(() => queryByText(LABELS.create_new_user));
      expect(queryByText(LABELS.create_new_user)).toBeNull();
      expect(fetch).not.toHaveBeenCalled();
    });

    it('sends a request when create button is clicked', async () => {
      const user = userEvent.setup()
  
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

      expect(queryByText(/User has been successfully created/))
    });

    it('displays an error when creation fails', async () => {
      const failureMessage = 'Unsuccessful user creation'
      fetchMock.mockResponseOnce(JSON.stringify({ error: failureMessage }), { status: 400 });
      const user = userEvent.setup()
  
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
      expect(fetch).toHaveBeenCalledTimes(1);

      await waitFor(() => expect(screen.getByText(failureMessage)).toBeInTheDocument());
      expect(queryByText(failureMessage))
    });
  });
});

