import { DataGrid, GridColDef, GridEventListener, GridRowParams } from '@mui/x-data-grid';
import { useEffect, useState } from 'react';
import CreateNewUser from '../CreateNewUser/CreateNewUser';
import { buildUrlParams } from '../../../helpers/utils';
import { useNavigate } from 'react-router-dom';
import type { ResponseError } from '../../types';

const columns: GridColDef[] = [
  { field: 'id', headerName: 'ID', width: 80 },
  { field: 'email', headerName: 'Email', flex: 2 },
  { field: 'json_web_token', headerName: 'token', flex: 3 },
  {
    field: 'created_at',
    headerName: 'Created At',
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
        initialState={{
          pagination: {
            paginationModel: { page: 0, pageSize: 10 },
          },
        }}
        onRowClick={handleRowClickEvent}
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
