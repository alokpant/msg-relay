import { DataGrid, GridColDef, GridEventListener, GridRowParams } from '@mui/x-data-grid';
import { useEffect, useState } from 'react';
import CreateNewUser from '../CreateNewUser/CreateNewUser';
import { buildUrlParams } from '../../../helpers/utils';
import { useNavigate } from 'react-router-dom';
import type { ResponseError } from '../../types';

export const ColHeaderNames = {
  ID: 'ID',
  EMAIL: 'Email',
  TOKEN: 'Token',
  CREATED_AT: 'Created At'
}

const columns: GridColDef[] = [
  { field: 'id', headerName: ColHeaderNames.ID, width: 80 },
  { field: 'email', headerName: ColHeaderNames.EMAIL, flex: 2 },
  { field: 'json_web_token', headerName: ColHeaderNames.TOKEN, flex: 3 },
  {
    field: 'created_at',
    headerName: ColHeaderNames.CREATED_AT,
    flex: 2,
  },
];

interface User {
  id: number
  email: string
  json_web_token: string
  created_at: string
}

const UserList = () => {
  const [users, setUsers] = useState<User[]>([]);
  const [refetchUsers, setRefetchUsers] = useState<boolean>(false);
  const navigate = useNavigate();

  useEffect(() => {
    const apiUrl = `http://localhost:3000/users?${buildUrlParams({ limit: '999' })}`;
    fetch(apiUrl)
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! Status: ${response.status}`);
        }
        return response.json();
      })
      .then((data: User[]) => {
        setUsers(data);
      })
      .catch((error: ResponseError) => {
        console.error('Error fetching data:', error?.message);
      });
  }, [refetchUsers])

  const handleRowClickEvent: GridEventListener<'rowClick'> = (
    params: GridRowParams<User>, // GridRowParams
  ) => {
    navigate(
      `/messages/${params?.id}`,
      { 
        state: {
          token: params?.row?.json_web_token,
          email: params?.row?.email
        }
      }
    )
  };
  
  return (
    <>
      <CreateNewUser setRefetchUsers={setRefetchUsers} />
      <DataGrid
        rows={users}
        columns={columns}
        data-testid='user-list'
        initialState={{
          pagination: {
            paginationModel: { page: 0, pageSize: 10 },
          },
        }}
        onRowClick={handleRowClickEvent}
        pageSizeOptions={[10, 50, 100]}
        sx={{
          width: '100%',
          background: '#fff'
        }}
        autoHeight={true}
      />
    </>
  );
}

export default UserList;
