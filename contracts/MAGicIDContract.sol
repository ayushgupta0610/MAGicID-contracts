pragma solidity ^0.4.20;
pragma experimental ABIEncoderV2;

import "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol";

// Changed MAGic to Magic
// Changed ua to userAddress
contract MagicIDContract is usingOraclize{


    address public contractOwner;
    mapping (bytes32 => uint16) uin_version;
    mapping (bytes32 => uint16) agency_version;
    bytes32 public uin;
    bytes32 public agencyID;
    bytes32 public uinOraclizeID;
    bytes32 public agencyIDOraclizeID;
    /* mapping (address => uint) AccessAgencyMap; */
    mapping (address => MagicIDStruct) address_MagicIDStruct;
    mapping (address => AccessAgencyStruct) address_AccessAgencyStruct;
    mapping (bytes32 => address[]) MagicIDUIN_AgencyAddress;
    mapping (bytes32 => address) AccessAgencyID_AccessAgencyAddress;
    mapping (bytes32 => address) uin_UserAddress;
    /* mapping (address => IDInstance) userAddress_IDInstance; */

    // Commented here
    /* mapping (address => IDInstance) User_AgencyMap; */

    /* mapping (bytes32 => MagicIDStruct) uin_MagicIDElement; */
    mapping (bytes32 => mapping(bytes32 => IDInstance)) uin_AgencyID_IDInstance;
    /* event IDAccessed(address from, MagicIDStruct whichID); */


    // Changed IDInstance
    struct IDInstance {
      uint time_fence;
      bytes32[] location_fence;
    }

    // Changed parentname to parentName, rightfinger to right_finger, leftfinger to left_finger
    struct MagicIDStruct {
      bytes32 uin;
      MagicIDStruct1 magicIDStruct1;
      MagicIDStruct2 magicIDStruct2;
      MagicIDStruct3 magicIDStruct3;
      MagicIDStruct4 magicIDStruct4;
    }

    struct MagicIDStruct1 {
      bytes32 name;
      bytes32 gender;
      bytes32 dob;
      bytes32 parentName;
      bytes32 personalAddress;
      bytes32 mobile;
      bytes32 email;
    }

    struct MagicIDStruct2 {
      bytes32 iris_left;
      bytes32 iris_right;
      bytes32 face;
    }

    struct MagicIDStruct3 {
      bytes32 right_finger_1;
      bytes32 right_finger_2;
      bytes32 right_finger_3;
      bytes32 right_finger_4;
      bytes32 right_finger_5;
    }

    struct MagicIDStruct4 {
      bytes32 left_finger_1;
      bytes32 left_finger_2;
      bytes32 left_finger_3;
      bytes32 left_finger_4;
      bytes32 left_finger_5;
    }
    string[] public uinArray;

    //MODIFIERS
    modifier isIDOwner(bytes32 uin) {
      if (msg.sender != uin_UserAddress[uin]) {
        throw;
      }
      _; // continue executing rest of method body
    }

    modifier isContractOwner() {
      if(msg.sender != contractOwner){
        throw;
      }
      _; // continue executing rest of method body
    }

    modifier isAccessAgency() {
      /* if(AccessAgencyMap[msg.sender] > 0) { */
      if(!address_AccessAgencyStruct[msg.sender].isActive) {
        throw;
      }
      _; // continue to access the ID info of the user (citizen)
    }

    function MagicIDContract() {
     contractOwner = msg.sender;
    }

    function createMagicID(bytes32 uin, bytes32[] _personal) returns (bool){
        uin_UserAddress[uin] = msg.sender;
        var magicID1 = createMagicID1(_personal);
        var magicID2 = createMagicID2(_personal);
        var magicID3 = createMagicID3(_personal);
        var magicID4 = createMagicID4(_personal);
        MagicIDStruct memory magicID = MagicIDStruct(uin, magicID1, magicID2, magicID3, magicID4);
        address_MagicIDStruct[msg.sender] = magicID;
        uinArray.push(bytes32ToString(uin));
        return true;
    }

    function createMagicID1(bytes32[] _personal) internal returns (MagicIDStruct1) {
      MagicIDStruct1 ID;
      ID.name = _personal[0];
      ID.gender = _personal[1];
      ID.dob = _personal[2];
      ID.parentName = _personal[3];
      ID.personalAddress = _personal[4];
      ID.mobile = _personal[5];
      ID.email = _personal[6];
      return ID;
    }

    function createMagicID2(bytes32[] _personal) internal returns (MagicIDStruct2) {
      MagicIDStruct2 ID;
      ID.iris_left = _personal[7];
      ID.iris_right = _personal[8];
      ID.face = _personal[9];
      return ID;
    }

    function createMagicID3(bytes32[] _personal) internal returns (MagicIDStruct3) {
      MagicIDStruct3 ID;
      ID.right_finger_1 = _personal[10];
      ID.right_finger_2 = _personal[11];
      ID.right_finger_3 = _personal[12];
      ID.right_finger_4 = _personal[13];
      ID.right_finger_5 = _personal[14];
      return ID;
    }

    function createMagicID4(
        bytes32[] _personal
        ) internal returns (MagicIDStruct4) {
      MagicIDStruct4 ID;
      ID.left_finger_1 = _personal[15];
      ID.left_finger_2 = _personal[16];
      ID.left_finger_3 = _personal[17];
      ID.left_finger_4 = _personal[18];
      ID.left_finger_5 = _personal[19];
      return ID;
    }

    // Removed keccak256 function here. Input _time_fence in s.
    function authID(bytes32 agency_id, uint _time_fence, bytes32[] _location_fence) payable returns (bool authIDStatus) {
      MagicIDStruct myMagicID = address_MagicIDStruct[msg.sender];
      bytes32 my_uin = myMagicID.uin;
      address agencyAddress = AccessAgencyID_AccessAgencyAddress[agency_id];
        // Instead of a modifier this will make sure that only the IDOowner aunthenticates himself/herself and the agency is active.
        require(msg.sender == uin_UserAddress[my_uin]);
        require(address_AccessAgencyStruct[agencyAddress].isActive == true);

      MagicIDUIN_AgencyAddress[my_uin].push(agencyAddress);
      uin_AgencyID_IDInstance[my_uin][agency_id].time_fence = now + _time_fence;
      uin_AgencyID_IDInstance[my_uin][agency_id].location_fence = _location_fence;

      // This is to set the uin_AgencyID_IDInstance[my_uin][agency_id].time_fence = 0 after the time_fence.
      uinOraclizeID = oraclize_query(_time_fence, "URL", strConcat("json(https://lottery-0610.herokuapp.com/revoke/", bytes32ToString(my_uin), "/", bytes32ToString(agency_id), ").uin"));
      agencyIDOraclizeID = oraclize_query(_time_fence, "URL", strConcat("json(https://lottery-0610.herokuapp.com/revoke/", bytes32ToString(my_uin), "/", bytes32ToString(agency_id), ").agencyID"));
      return  true;
    }

    function getMagicIDFromUIN(bytes32 uin) constant internal returns (MagicIDStruct storage) {
      address userAddress = uin_UserAddress[uin];
      return address_MagicIDStruct[userAddress];
    }

    // Change return variables' names here
    function getIDUIN(bytes32 uin) constant isAccessAgency returns (bool isRet, string ret_uin) {
      AccessAgencyStruct queryingAgency = address_AccessAgencyStruct[msg.sender];
      if(uin_AgencyID_IDInstance[uin][queryingAgency.agency_id].time_fence < now){
        return (false, "");
      }
      MagicIDStruct storage magicID = getMagicIDFromUIN(uin);
      return (true, bytes32ToString(magicID.uin));
    }

    // Change return variables' names here
    function getIDName(bytes32 uin) constant isAccessAgency returns (bool isRet, string ret_name) {
        AccessAgencyStruct queryingAgency = address_AccessAgencyStruct[msg.sender];
        if(uin_AgencyID_IDInstance[uin][queryingAgency.agency_id].time_fence < now){
          return (false, "");
        }
        require(queryingAgency.accessAgencyStruct2.isAllowedName);
      MagicIDStruct storage magicID = getMagicIDFromUIN(uin);
      return (true, bytes32ToString(magicID.magicIDStruct1.name));
    }

    // Change return variables' names here
    function getIDGender(bytes32 uin) constant isAccessAgency returns (bool isRet, string ret_gender) {
        AccessAgencyStruct queryingAgency = address_AccessAgencyStruct[msg.sender];
        if(uin_AgencyID_IDInstance[uin][queryingAgency.agency_id].time_fence < now){
          return (false, "");
        }
        require(queryingAgency.accessAgencyStruct2.isAllowedGender);
      MagicIDStruct storage magicID = getMagicIDFromUIN(uin);
      return (true, bytes32ToString(magicID.magicIDStruct1.gender));
    }

    // Change return variables' names here
    function getIDdob(bytes32 uin) constant isAccessAgency returns (bool isRet, string ret_dob) {
        AccessAgencyStruct queryingAgency = address_AccessAgencyStruct[msg.sender];
        if(uin_AgencyID_IDInstance[uin][queryingAgency.agency_id].time_fence < now){
          return (false, "");
        }
        require(queryingAgency.accessAgencyStruct2.isAllowedDOB);
      MagicIDStruct storage magicID = getMagicIDFromUIN(uin);
      return (true, bytes32ToString(magicID.magicIDStruct1.dob));
    }

    // Change return variables' names here
    function getIDParentName(bytes32 uin) constant isAccessAgency returns (bool isRet, string ret_parentName) {
        AccessAgencyStruct queryingAgency = address_AccessAgencyStruct[msg.sender];
        if(uin_AgencyID_IDInstance[uin][queryingAgency.agency_id].time_fence < now){
          return (false, "");
        }
        require(queryingAgency.accessAgencyStruct2.isAllowedParentName);
      MagicIDStruct storage magicID = getMagicIDFromUIN(uin);
      return (true, bytes32ToString(magicID.magicIDStruct1.parentName));
    }

    // Change return variables' names here
    function getIDaddress(bytes32 uin) constant isAccessAgency returns (bool isRet, string ret_personalAddress) {
        AccessAgencyStruct queryingAgency = address_AccessAgencyStruct[msg.sender];
        if(uin_AgencyID_IDInstance[uin][queryingAgency.agency_id].time_fence < now){
          return (false, "");
        }
        require(queryingAgency.accessAgencyStruct2.isAllowedAddress);
      MagicIDStruct storage magicID = getMagicIDFromUIN(uin);
      return (true, bytes32ToString(magicID.magicIDStruct1.personalAddress));
    }

    // Change return variables' names here
    function getIDmobile(bytes32 uin) constant isAccessAgency returns (bool isRet, string ret_mobile) {
        AccessAgencyStruct queryingAgency = address_AccessAgencyStruct[msg.sender];
        if(uin_AgencyID_IDInstance[uin][queryingAgency.agency_id].time_fence < now){
          return (false, "");
        }
        require(queryingAgency.accessAgencyStruct2.isAllowedMobile);
      MagicIDStruct storage magicID = getMagicIDFromUIN(uin);
      return (true, bytes32ToString(magicID.magicIDStruct1.mobile));
    }

    // Change return variables' names here
    function getIDemail(bytes32 uin) constant isAccessAgency returns (bool isRet, string ret_email) {
        AccessAgencyStruct queryingAgency = address_AccessAgencyStruct[msg.sender];
        if(uin_AgencyID_IDInstance[uin][queryingAgency.agency_id].time_fence < now){
          return (false, "");
        }
        require(queryingAgency.accessAgencyStruct3.isAllowedEmail);
      MagicIDStruct storage magicID = getMagicIDFromUIN(uin);
      return (true, bytes32ToString(magicID.magicIDStruct1.email));
    }

    // Change return variables' names here
    /* function getIDCurrentLoc(bytes32 uin) isAccessAgency returns (bool isRet, bytes32 ret_current_loc) {
        AccessAgencyStruct queryingAgency = address_AccessAgencyStruct[msg.sender];
        if(uin_AgencyID_IDInstance[uin][queryingAgency.agency_id].time_fence < now){
          return (false, "");
        }
        require(queryingAgency.isAllowedCurrentLoc);
      MagicIDStruct storage magicID = getMagicIDFromUIN(uin);
      return (true, magicID.current_loc);
    } */

    // Change return variables' names here
    function getBioIRIS(bytes32 uin) constant isAccessAgency returns (bool isRet, string ret_iris_left, string ret_iris_right) {
        AccessAgencyStruct queryingAgency = address_AccessAgencyStruct[msg.sender];
        if(uin_AgencyID_IDInstance[uin][queryingAgency.agency_id].time_fence < now){
          return (false, "", "");
        }
        require(queryingAgency.accessAgencyStruct3.isAllowedBioIRIS);
      MagicIDStruct storage magicID = getMagicIDFromUIN(uin);
      return (true, bytes32ToString(magicID.magicIDStruct2.iris_left), bytes32ToString(magicID.magicIDStruct2.iris_right));
    }

    // Change return variables' names here
    function getBioFace(bytes32 uin) constant isAccessAgency returns (bool isRet, string ret_face) {
        AccessAgencyStruct queryingAgency = address_AccessAgencyStruct[msg.sender];
        if(uin_AgencyID_IDInstance[uin][queryingAgency.agency_id].time_fence < now){
          return (false, "");
        }
        require(queryingAgency.accessAgencyStruct3.isAllowedBioFace);
      MagicIDStruct storage magicID = getMagicIDFromUIN(uin);
      return (true, bytes32ToString(magicID.magicIDStruct2.face));
    }

    // Change return variables' names here
    function getBioRightFingers(bytes32 uin) constant isAccessAgency returns (bool isRet, string ret_right_finger_1, string ret_right_finger_2, string ret_right_finger_3, string ret_right_finger_4,string ret_right_finger_5) {
          AccessAgencyStruct queryingAgency = address_AccessAgencyStruct[msg.sender];
          if(uin_AgencyID_IDInstance[uin][queryingAgency.agency_id].time_fence < now){
            return (false, "", "", "", "", "");
          }
        require(queryingAgency.accessAgencyStruct3.isAllowedBioRightFingers);
      MagicIDStruct storage magicID = getMagicIDFromUIN(uin);
      return (true, bytes32ToString(magicID.magicIDStruct3.right_finger_1), bytes32ToString(magicID.magicIDStruct3.right_finger_2), bytes32ToString(magicID.magicIDStruct3.right_finger_3), bytes32ToString(magicID.magicIDStruct3.right_finger_4), bytes32ToString(magicID.magicIDStruct3.right_finger_5));
    }

    // Change return variables' names here
    function getBioLeftFingers(bytes32 uin) constant isAccessAgency returns (bool isRet, string ret_left_finger_1, string ret_left_finger_2, string ret_left_finger_3, string ret_left_finger_4, string ret_left_finger_5) {
          AccessAgencyStruct queryingAgency = address_AccessAgencyStruct[msg.sender];
          if(uin_AgencyID_IDInstance[uin][queryingAgency.agency_id].time_fence < now){
            return (false, "", "", "", "", "");
          }
        require(queryingAgency.accessAgencyStruct3.isAllowedBioLeftFingers);
      MagicIDStruct storage magicID = getMagicIDFromUIN(uin);
      return (true, bytes32ToString(magicID.magicIDStruct4.left_finger_1), bytes32ToString(magicID.magicIDStruct4.left_finger_2), bytes32ToString(magicID.magicIDStruct4.left_finger_3), bytes32ToString(magicID.magicIDStruct4.left_finger_4), bytes32ToString(magicID.magicIDStruct4.left_finger_5));
    }

    // uin_AgencyID_IDInstance for _uin => time_fence = 0.
    function revokeID(bytes32 _uin, bytes32 _agencyID) internal returns (bool revokeIDStatus) {
      uin_AgencyID_IDInstance[_uin][_agencyID].time_fence = 0;
      return true;
    }

    function __callback(bytes32 oraclizeID, string _result){
        // if(msg.sender != oraclize_cbAddress() || msg.sender != uin_UserAddress[stringToBytes32(_result[0])]) throw;
        if(msg.sender == oraclize_cbAddress() && oraclizeID == uinOraclizeID){
          uin = stringToBytes32(_result);
          uin_version[uin] += 1;
        }
        if(msg.sender == oraclize_cbAddress() && oraclizeID == agencyIDOraclizeID){
          agencyID = stringToBytes32(_result);
          agency_version[agencyID] += 1;
        }
        // If uinOraclizeID and agencyIDOraclizeID are both true for the same version
        if(uin_version[uin] == agency_version[agencyID]){
         revokeID(uin, agencyID);
        }
    }

    // Check here. Returns the addresses of the agencies who accessed user's uin (or wherever the person entered). Modifier required.
    function getIDAccessors(bytes32 uin) constant isIDOwner(uin) returns (address[] accessorsArray) {
      accessorsArray = MagicIDUIN_AgencyAddress[uin];
    }

    // Returns name and domain of the agency when given agency's address. Can be called by user as well as other agencies.
    function nameResolveAgency(address _agencyAddress) returns (string, string) {
      AccessAgencyStruct agency = address_AccessAgencyStruct[_agencyAddress];
      return (bytes32ToString(agency.agency_name), bytes32ToString(agency.agency_domain));
    }

    // Code here. Who can set isActive to false? contractOwner? Resorting with contractOwner for now.
    function setAgencyAccess(bytes32 _agency_id, bool _isActive) returns (bool setAgencyAccessStatus) {
      address accessAgency = AccessAgencyID_AccessAgencyAddress[_agency_id];
      address_AccessAgencyStruct[accessAgency].isActive = _isActive;
      return true;
    }

    struct AccessAgencyStruct {
      bytes32 agency_id;
      bytes32 agency_name;
      bytes32 agency_domain;
      bool isActive;
      AccessAgencyStruct2 accessAgencyStruct2;
      AccessAgencyStruct3 accessAgencyStruct3;
    }

    struct AccessAgencyStruct2 {
      bool isAllowedName;
      bool isAllowedGender;
      bool isAllowedDOB;
      bool isAllowedParentName;
      bool isAllowedAddress;
      bool isAllowedMobile;
    }

    struct AccessAgencyStruct3 {
      bool isAllowedEmail;
      bool isAllowedBioIRIS;
      bool isAllowedBioFace;
      bool isAllowedBioRightFingers;
      bool isAllowedBioLeftFingers;
    }
    string[] public AccessAgencyArray;

    function createAccessAgency(bytes32 agency_id, bytes32 _agency_name, bytes32 _agency_domain, bool[] _features) returns (bool){
        AccessAgencyID_AccessAgencyAddress[agency_id] = msg.sender;
        var accessAgency2 = createAccessAgency2(_features);
        var accessAgency3 = createAccessAgency3(_features);
        // Setting isActive of agency to false. Who can set it to true is still a mystery!
        AccessAgencyStruct memory agency = AccessAgencyStruct(agency_id, _agency_name, _agency_domain, false, accessAgency2, accessAgency3);
        address_AccessAgencyStruct[msg.sender] = agency;
        AccessAgencyArray.push(bytes32ToString(agency_id));
        return true;
    }

    function createAccessAgency2(
        bool[] _features
        ) internal returns (AccessAgencyStruct2) {
      AccessAgencyStruct2 agencyStruct;
      agencyStruct.isAllowedName = _features[0];
      agencyStruct.isAllowedGender = _features[1];
      agencyStruct.isAllowedDOB = _features[2];
      agencyStruct.isAllowedParentName = _features[3];
      agencyStruct.isAllowedAddress = _features[4];
      agencyStruct.isAllowedMobile = _features[5];
      return agencyStruct;
    }

    function createAccessAgency3(
        bool[] _features
        ) internal returns (AccessAgencyStruct3) {
      AccessAgencyStruct3 agencyStruct;
      agencyStruct.isAllowedEmail = _features[6];
      agencyStruct.isAllowedBioIRIS = _features[7];
      agencyStruct.isAllowedBioFace = _features[8];
      agencyStruct.isAllowedBioRightFingers = _features[9];
      agencyStruct.isAllowedBioLeftFingers = _features[10];
      return agencyStruct;
    }

    function bytes32ToString(bytes32 x) constant returns (string) {
        bytes memory bytesString = new bytes(32);
        uint charCount = 0;
        for (uint j = 0; j < 32; j++) {
            byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
            if (char != 0) {
                bytesString[charCount] = char;
                charCount++;
            }
        }
        bytes memory bytesStringTrimmed = new bytes(charCount);
        for (j = 0; j < charCount; j++) {
            bytesStringTrimmed[j] = bytesString[j];
        }
        return string(bytesStringTrimmed);
    }

    function stringToBytes32(string memory source) returns (bytes32 result) {
      bytes memory tempEmptyStringTest = bytes(source);
      if (tempEmptyStringTest.length == 0) {
        return 0x0;
      }
      assembly {
          result := mload(add(source, 32))
      }
    }

    function getAgencyCount() returns (uint){
        return AccessAgencyArray.length;
    }

    function getMemberCount() returns (uint){
        return uinArray.length;
    }
  }
