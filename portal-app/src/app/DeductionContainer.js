import React from "react";
import {Route, Switch, useHistory} from "react-router-dom";
import DeductionForm from "../deduction-form/DeductionForm";
import Confirmation from "../confirmation/Confirmation";
import Success from "../success/Success";
import Login from "../login/Login";
// import Auth from "../auth/Auth"
import NHSIdentitySandpitLogInUrl from "../config";

const DeductionContainer = () => {
  const history = useHistory();

  return <Switch>
      <Route exact path="/">
          <Login login={() => window.location.href = `${NHSIdentitySandpitLogInUrl}`} loginMock={() => history.push("/home")}/>
      </Route>
      <Route path="/auth">
          <DeductionForm submitDeduction={() => history.push("/confirmation")}
                         validateNhsNumber={validateNhsNumber}/>
      </Route>
      <Route path='/home'>
          <DeductionForm submitDeduction={() => history.push("/confirmation")}
                         validateNhsNumber={validateNhsNumber}/>
      </Route>
      <Route path='/confirmation'>
          <Confirmation confirmDeduction={() => history.push("/success")}/>
      </Route>
      <Route path="/success">
          <Success/>
      </Route>
  </Switch>;
};

const validateNhsNumber = (nhsNumber) => {
    const nhsNumRegex = /^\d{10,20}$/;
    if (!nhsNumRegex.test(nhsNumber)) {
        return "No Patient found with that NHS Number";
    } else if (nhsNumber.charAt(0) === "9") {
        return "Patient is not in your practice";
    } else {
        return "";
    }
};

export default DeductionContainer;
