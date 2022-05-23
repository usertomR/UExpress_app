import { REQUEST_STATE } from '../constant';

export const initialState = {
  fetchState: REQUEST_STATE.INITIAL,
  login: "",
  login_and_admin: "",
  user_id: "",
};

export const FristReactActionTypes = {
  FETCHING: 'FETCHING',
  FETCH_SUCCESS: 'FETCH_SUCCESS'
}

export const FirstReactReducer = (state, action) => {
  switch (action.type) {
    case FristReactActionTypes.FETCHING:
      return {
        ...state,
        fetchState: REQUEST_STATE.LOADING,
      };
    case FristReactActionTypes.FETCH_SUCCESS:
      return {
        fetchState: REQUEST_STATE.OK,
        login: action.payload.login,
        login_and_admin: action.payload.login_and_admin,
        user_id: action.payload.user_id,
      };
    default:
      throw new Error();
  }
}
