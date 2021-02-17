// ++++++++++++++++++++++++++++++++++++++++++++++ Backend Errors ++++++++++++++++++++++++++++++++++++++++++++++

/// TransactionBaseLimitErrorB is a constant that holds transaction base limit error of the backend
const TransactionBaseLimitErrorB = "amount is less than transaction base limit";

/// WithdrawBaseLimitErrorB is a constant that holds withdraw base limit error of the backend
const WithdrawBaseLimitErrorB = "amount is less than the withdraw base limit";

/// DailyTransactionLimitErrorB is a constant that holds daily transaction limit error of the backend
const DailyTransactionLimitErrorB = "user has exceeded daily transaction limit";

/// InsufficientBalanceErrorB is a constant that holds insufficient balance error of the backend
const InsufficientBalanceErrorB =
    "insufficient balance, please recharge your wallet";

/// SenderNotFoundErrorB is a constant that holds sender not found error of the backend
const SenderNotFoundErrorB = "no onepay user for the provided sender id";

/// ReceiverNotFoundErrorB is a constant that holds receiver not found error of the backend
const ReceiverNotFoundErrorB = "no onepay user for the provided receiver id";

/// TransactionWSelfErrorB is a constant that holds transaction with our own account is not allowed error of the backend
const TransactionWSelfErrorB = "cannot make transaction with your own account";

/// AmountParsingErrorB is a constant that holds amount parsing error of the backend
const AmountParsingErrorB = "amount parsing error";

/// FrozenAccountErrorB is a constant that holds frozen account error of the backend
const FrozenAccountErrorB = "account has been frozen";

/// FrozenAPIClientErrorB is a constant that holds api client has been frozen error of the backend
const FrozenAPIClientErrorB = "api client has been frozen";

/// InvalidPasswordOrIdentifierErrorB is a constant that holds invalid password or identifier error of the backend
const InvalidPasswordOrIdentifierErrorB = "invalid identifier or password used";

/// TooManyAttemptsErrorB is a constant that holds too many attempts error of the backend
const TooManyAttemptsErrorB = "too many attempts try after 24 hours";

/// InvalidPasswordErrorB is a constant that holds invalid password used error of the backend
const InvalidPasswordErrorB = "invalid password used";

/// InvalidIdentifierErrorB is a constant that holds invalid identifier used error of the backend
const InvalidIdentifierErrorB = "invalid identifier used";

/// EmailAlreadyExistsErrorB is a constant that holds email address already exists error of the backend
const EmailAlreadyExistsErrorB = "email address already exists";

/// PhoneNumberAlreadyExistsErrorB is a constant that holds phone number already exists error of the backend
const PhoneNumberAlreadyExistsErrorB = "phone number already exists";

/// InvalidCharacterInPasswordErrorB is a constant that holds invalid characters in password error of the backend
const InvalidCharacterInPasswordErrorB = "invalid characters used in password";

/// PasswordLengthErrorB is a constant that holds password too short error of the backend
const PasswordLengthErrorB = "password should contain at least 8 characters";

/// PasswordDontMatchErrorB is a constant that holds password doesn't match error of the backend
const PasswordDontMatchErrorB = "passwords do not match";

/// IdenticalPasswordErrorB is a constant that holds new password is identical with old one error of the backend
const IdenticalPasswordErrorB =
    "new password is identical with the old password";

/// InvalidMoneyTokenErrorB is a constant that holds invalid money token used error of the backend
const InvalidMoneyTokenErrorB = "invalid money token used";

/// ExpiredMoneyTokenErrorB is a constant that holds money token had expired error of the backend
const ExpiredMoneyTokenErrorB = "money token has passed expiration date";

/// InvalidMethodErrorB is a constant that holds invalid method used error of the backend
const InvalidMethodErrorB = "invalid method, code not found";

/// LinkedAccountNotFoundB is a constant that holds linked account not found error of the backend
const LinkedAccountNotFoundB = "linked account not found";

/// LinkedAccountInsufficientBalanceB is a constant that holds linked account with insufficient balance error of the backend
const LinkedAccountInsufficientBalanceB =
    "insufficient balance, please recharge your linked account";

/// AccountProviderNotFoundB is a constant that holds account provider not found error of the backend
const AccountProviderNotFoundB = "account provider not found";

/// AccountAlreadyLinkedErrorB is a constant that holds account has already been linked error of the backend
const AccountAlreadyLinkedErrorB =
    "account has already been linked to other onepay account";

/// UnDrainedWalletErrorB is a constant that holds drain your wallet first error of the backend
const UnDrainedWalletErrorB =
    "please empty your wallet before deleting account";

/// UnClaimedMoneyTokenErrorB is a constant that holds claim money tokens first error of the backend
const UnClaimedMoneyTokenErrorB =
    "please delete or reclaim all money tokens that has not been received before deleting account";

// ++++++++++++++++++++++++++++++++++++++++++++++ Frontend Errors ++++++++++++++++++++++++++++++++++++++++++++++

/// TransactionBaseLimitError is a constant that holds transaction base limit error
const TransactionBaseLimitError = "amount is less than transaction base limit";

/// WithdrawBaseLimitError is a constant that holds withdraw base limit error
const WithdrawBaseLimitError = "amount is less than the withdraw base limit";

/// DailyTransactionLimitSendError is a constant that holds daily transaction limit for send error
const DailyTransactionLimitSendError =
    "you has exceeded daily transaction limit";

/// DailyTransactionLimitPaymentError is a constant that holds daily transaction limit for payment error
const DailyTransactionLimitPaymentError =
    "amount has exceeded daily transaction limit";

/// InsufficientBalanceError is a constant that holds insufficient balance error
const InsufficientBalanceError =
    "insufficient balance, please recharge your wallet";

/// SenderNotFoundError is a constant that holds sender not found error
const SenderNotFoundError = "no onepay user for the provided sender id";

/// ReceiverNotFoundError is a constant that holds receiver not found error
const ReceiverNotFoundError = "no onepay user for the provided receiver id";

/// TransactionWSelfError is a constant that holds transaction with our own account is not allowed error
const TransactionWSelfError = "cannot make transaction with your own account";

/// InvalidAmountError is a constant that holds invalid amount error
const InvalidAmountError = "invalid amount";

/// UnableToConnectError is a constant that holds unable to connect error
const UnableToConnectError = "unable to connect";

/// FailedOperationError is a constant that holds unable to perform operation error
const FailedOperationError = "unable to perform operation";

/// SomethingWentWrongError is a constant that holds something went wrong error
const SomethingWentWrongError = "oops something went wrong";

/// EmptyEntryError is a constant that holds empty entry error
const EmptyEntryError = "entry should be filled";

/// InvalidPhoneNumberError is a constant that holds invalid phone number used error
const InvalidPhoneNumberError = "invalid phone number used";

/// InvalidEmailAddressError is a constant that holds invalid email address used error
const InvalidEmailAddressError = "invalid email address used";

/// InvalidCharacterInPasswordError is a constant that holds invalid characters in password error
const InvalidCharacterInPasswordError = "invalid characters used in password";

/// PasswordLengthError is a constant that holds password too short error
const PasswordLengthError = "password should contain at least 8 characters";

/// PasswordDontMatchError is a constant that holds password doesn't match error
const PasswordDontMatchError = "passwords do not match";

/// IdenticalPasswordError is a constant that holds new password is identical with old one error
const IdenticalPasswordError = "new password is identical with the old one";

/// FrozenReceiverAccountError is a constant that holds frozen receiver account error
const FrozenReceiverAccountError = "receiver account has been frozen";

/// FrozenAccountError is a constant that holds frozen account error
const FrozenAccountError = "receiver account has been frozen";

/// FrozenAPIClientError is a constant that holds api client has been frozen error
const FrozenAPIClientError = "api client has been frozen";

/// InvalidPasswordOrIdentifierError is a constant that holds invalid password or identifier error
const InvalidPasswordOrIdentifierError = "invalid identifier or password used";

/// TooManyAttemptsError is a constant that holds too many attempts error
const TooManyAttemptsError = "too many attempts try after 24 hours";

/// InvalidPasswordError is a constant that holds invalid password used error
const InvalidPasswordError = "invalid password used";

/// EmailAlreadyExistsError is a constant that holds email address already exists error
const EmailAlreadyExistsError = "email address already exists";

/// PhoneNumberAlreadyExistsError is a constant that holds phone number already exists error
const PhoneNumberAlreadyExistsError = "phone number already exists";

/// InvalidMoneyTokenError is a constant that holds invalid money token used error
const InvalidMoneyTokenError = "invalid code used";

/// ExpiredMoneyTokenError is a constant that holds money token had expired error
const ExpiredMoneyTokenError = "money token has passed expiration date";

/// InvalidMethodError is a constant that holds invalid method used error
const InvalidMethodError = "invalid method, code not found";

/// LinkedAccountNotFound is a constant that holds linked account not found error
const LinkedAccountNotFound = "invalid linked account used";

/// LinkedAccountInsufficientBalance is a constant that holds linked account with insufficient balance error
const LinkedAccountInsufficientBalance =
    "insufficient balance, \nplease recharge your linked account";

/// AccountProviderNotFound is a constant that holds account provider not found error
const AccountProviderNotFound = "invalid provider, please refresh your list";

/// AccountAlreadyLinkedError is a constant that holds account has already been linked error
const AccountAlreadyLinkedError = "account has already been linked";

/// UnDrainedWalletError is a constant that holds drain your wallet first error
const UnDrainedWalletError = "please empty your OnePay wallet first";

/// UnClaimedMoneyTokenError is a constant that holds claim money tokens first error
const UnClaimedMoneyTokenError = "unclaimed money token found";
