pragma solidity ^0.4.19;


contract MAGicIDContract {
    address public IDOwner;
    mapping (address => uint) AccessAgencyMap;
    mapping (address => MAGicIDStruct) address_MAGicIDStruct;
    mapping (address => AccessAgencyStruct) address_AccessAgencyStruct;
    mapping (string => address[]) MagicIDUIN_AgencyAddress;
    mapping (string => address) AccessAgencyID_AccessAgencyAddress;
    /* mapping (address => IDInstance) userAddress_IDInstace; */
    mapping (address => IDInstance) User_AgencyMap;
    mapping (string => MAGicIDStruct) uin_MagicIDElement;
    mapping (string => address) uin_UserAddress;

    struct IDInstance {
      string ID_UIN;
      string AccessAgencyID;
      uint time_fence;
      bytes32[] location_fence;
    }
    IDInstance[] IDInstanceArray;

    struct MAGicIDStruct {
      string bg_uin;
      string bg_name;
      string bg_gender;
      string bg_dob;
      string bg_parentname;
      string bg_address;
      string bg_mobile;
      string bg_email;

      bool isActive;
      string current_loc;

      string bm_iris_left;
      string bm_iris_right;
      string bm_face;
      string bm_rightfinger_1;
      string bm_rightfinger_2;
      string bm_rightfinger_3;
      string bm_rightfinger_4;
      string bm_rightfinger_5;
      string bm_leftfinger_1;
      string bm_leftfinger_2;
      string bm_leftfinger_3;
      string bm_leftfinger_4;
      string bm_leftfinger_5;
    }
    MAGicIDStruct[] public MagicIDArray;


    struct AccessAgencyStruct {
      string agency_id;
      string agency_name;
      string agency_domain;
      bool isAllowedName;
      bool isAllowedGender;
      bool isAllowedDOB;
      bool isAllowedParentName;
      bool isAllowedAddress;
      bool isAllowedMobile;
      bool isAllowedEmail;
      bool isAllowedCurrentLoc;
      bool isAllowedBioIRIS;
      bool isAllowedBioFace;
      bool isAllowedBioRightFingers;
      bool isAllowedBioLeftFingers;
    }
    AccessAgencyStruct[] public AccessAgencyArray;

    //MODIFIERS
    modifier isIDOwner() {
      if (msg.sender != IDOwner) {
        throw;
      }
      _; // continue executing rest of method body
    }

    modifier isAccessAgency() {
      if(AccessAgencyMap[msg.sender] > 0) {
        throw;
      }
      _; // continue to access the ID info of the user (citizen)
    }

    function MAGicIDContract() {
      IDOwner = msg.sender;
    }

    function createMagicID(string _bg_uin,
    string _bg_name,
    string _bg_gender,
    string _bg_dob,
    string _bg_parentname,
    string _bg_address,
    string _bg_mobile,
    string _bg_email,
    string _bm_iris_left,
    string _bm_iris_right,
    string _bm_face,
    string _bm_rightfinger_1,
    string _bm_rightfinger_2,
    string _bm_rightfinger_3,
    string _bm_rightfinger_4,
    string _bm_rightfinger_5,
    string _bm_leftfinger_1,
    string _bm_leftfinger_2,
    string _bm_leftfinger_3,
    string _bm_leftfinger_4,
    string _bm_leftfinger_5) returns (bool createMagicIDStatus) {
      uin_UserAddress[msg.sender] = _bg_uin;
      var ID = address_MAGicIDStruct[msg.sender];
      ID.bg_uin = _bg_uin;
      ID.bg_name = _bg_name;
      ID.bg_gender = _bg_gender;
      ID.bg_dob = _bg_dob;
      ID.bg_parentname = _bg_parentname;
      ID.bg_address = _bg_address;
      ID.bg_mobile = _bg_mobile;
      ID.bg_email = _bg_email;

      ID.bm_iris_left = _bm_iris_left;
      ID.bm_iris_right = _bm_iris_right;
      ID.bm_face = _bm_face;
      ID.bm_rightfinger_1 = _bm_rightfinger_1;
      ID.bm_rightfinger_2 = _bm_rightfinger_2;
      ID.bm_rightfinger_3 = _bm_rightfinger_3;
      ID.bm_rightfinger_4 = _bm_rightfinger_4;
      ID.bm_rightfinger_5 = _bm_rightfinger_5;
      ID.bm_leftfinger_1 = _bm_leftfinger_1;
      ID.bm_leftfinger_2 = _bm_leftfinger_2;
      ID.bm_leftfinger_3 = _bm_leftfinger_3;
      ID.bm_leftfinger_4 = _bm_leftfinger_4;
      ID.bm_leftfinger_5 = _bm_leftfinger_5;
      MagicIDArray.push(ID);
      return true;
    }

    function authID(string _agency_id, uint _time_fence, bytes32[] _location_fence) isIDOwner() returns (bool authIDStatus) {
      MAGicIDStruct myMagicID = address_MAGicIDStruct[msg.sender];
      string my_uin = myMagicID.bg_uin;
      address agencyAddress = AccessAgencyID_AccessAgencyAddress[_agency_id];
      MagicIDUIN_AgencyAddress[my_uin].push(agencyAddress);
      var newIDInstance = User_AgencyMap[msg.sender];
      newIDInstance.ID_UIN = my_uin;
      newIDInstance.AccessAgencyID = _agency_id;
      newIDInstance.time_fence = _time_fence;
      newIDInstance.location_fence = _location_fence;
      for(uint d = 0; d < IDInstanceArray.length; d++) {
        if (IDInstanceArray[d].ID_UIN == my_uin && IDInstanceArray[d].AccessAgencyID == _agency_id){
          IDInstanceArray[d].time_fence = _time_fence;
          IDInstanceArray[d].location_fence = _location_fence;
        }
      }
      IDInstanceArray.push(newIDInstance);
      return  true;
    }

    function readID(string _bg_uin) returns (string ret_bg_uin,
      string ret_bg_name,
      string ret_bg_dob,
      string ret_bg_parentname,
      string ret_bg_address,
      string ret_bg_mobile,
      string ret_bg_email,
      string ret_current_loc,
      string ret_bm_iris_left,
      string ret_bm_iris_right,
      string ret_bm_face,
      string ret_bm_rightfinger_1,
      string ret_bm_rightfinger_2,
      string ret_bm_rightfinger_3,
      string ret_bm_rightfinger_4,
      string ret_bm_rightfinger_5,
      string ret_bm_leftfinger_1,
      string ret_bm_leftfinger_2,
      string ret_bm_leftfinger_3,
      string ret_bm_leftfinger_4,
      string ret_bm_leftfinger_5
      ) {
        AccessAgencyStruct queryingAgency = address_AccessAgencyStruct[msg.sender];
        for(uint e = 0; e < IDInstanceArray.length; e++) {
          if(IDInstanceArray[e].ID_UIN == _bg_uin && IDInstanceArray[e].AccessAgencyID == queryingAgency.agency_id){
            if(IDInstanceArray[e].time_fence > now){
              return false;
            }
          }
        }
        if(queryingAgency.isAllowedName == true &&
          queryingAgency.isAllowedGender == true &&
          queryingAgency.isAllowedDOB == true &&
          queryingAgency.isAllowedParentName == true &&
          queryingAgency.isAllowedAddress == true &&
          queryingAgency.isAllowedMobile == true &&
          queryingAgency.isAllowedEmail == true &&
          queryingAgency.isAllowedCurrentLoc == true &&
          queryingAgency.isAllowedBioIRIS == true &&
          queryingAgency.isAllowedBioFace == true &&
          queryingAgency.isAllowedBioRightFingers == true &&
          queryingAgency.isAllowedBioLeftFingers == true) {
            return (getIDUIN(_bg_uin), getIDName(_bg_uin), getIDGender(_bg_uin), getIDdob(_bg_uin), getIDparentname(_bg_uin), getIDaddress(_bg_uin), getIDmobile(_bg_uin), getIDemail(_bg_uin), getIDCurrentLoc(_bg_uin), getBioIRIS(_bg_uin), getBioFace(_bg_uin), getBioRightFingers(_bg_uin), getBioLeftFingers(_bg_uin));
        }
    }

    function getIDUIN(string _bg_uin) returns (string ret_bg_uin) {
      address ua = uin_UserAddress[_bg_uin];
      MAGicIDStruct magicID = address_MAGicIDStruct[ua];
      return magicID.bg_uin;
    }

    function getIDName(string _bg_uin) returns (string ret_bg_name) {
      address ua = uin_UserAddress[_bg_uin];
      MAGicIDStruct magicID = address_MAGicIDStruct[ua];
      return magicID.bg_name;
    }

    function getIDGender(string _bg_uin) returns (string ret_bg_gender) {
      address ua = uin_UserAddress[_bg_uin];
      MAGicIDStruct magicID = address_MAGicIDStruct[ua];
      return magicID.bg_gender;
    }

    function getIDdob(string _bg_uin) returns (string ret_bg_dob) {
      address ua = uin_UserAddress[_bg_uin];
      MAGicIDStruct magicID = address_MAGicIDStruct[ua];
      return magicID.bg_dob;
    }

    function getIDparentname(string _bg_uin) returns (string ret_bg_parentname) {
      address ua = uin_UserAddress[_bg_uin];
      MAGicIDStruct magicID = address_MAGicIDStruct[ua];
      return magicID.bg_parentname;
    }

    function getIDaddress(string _bg_uin) returns (string ret_bg_address) {
      address ua = uin_UserAddress[_bg_uin];
      MAGicIDStruct magicID = address_MAGicIDStruct[ua];
      return magicID.bg_address;
    }

    function getIDmobile(string _bg_uin) returns (string ret_bg_mobile) {
      address ua = uin_UserAddress[_bg_uin];
      MAGicIDStruct magicID = address_MAGicIDStruct[ua];
      return magicID.bg_mobile;
    }

    function getIDemail(string _bg_uin) returns (string ret_bg_email) {
      address ua = uin_UserAddress[_bg_uin];
      MAGicIDStruct magicID = address_MAGicIDStruct[ua];
      return magicID.bg_email;
    }

    function getIDCurrentLoc(string _bg_uin) returns (string ret_bg_current_loc) {
      address ua = uin_UserAddress[_bg_uin];
      MAGicIDStruct magicID = address_MAGicIDStruct[ua];
      return magicID.current_loc;
    }

    function getBioIRIS(string _bg_uin) returns (string ret_bm_iris_left, string ret_bm_iris_right) {
      address ua = uin_UserAddress[_bg_uin];
      MAGicIDStruct magicID = address_MAGicIDStruct[ua];
      return (magicID.bm_iris_left, magicID.bm_iris_right);
    }

    function getBioFace(string _bg_uin) returns (string ret_bm_face) {
      address ua = uin_UserAddress[_bg_uin];
      MAGicIDStruct magicID = address_MAGicIDStruct[ua];
      return (magicID.bm_face);
    }

    function getBioRightFingers(string _bg_uin) returns (string ret_bm_rightfinger_1,
      string ret_bm_rightfinger_2,
      string ret_bm_rightfinger_3,
      string ret_bm_rightfinger_4,
      string ret_bm_rightfinger_5) {
      address ua = uin_UserAddress[_bg_uin];
      MAGicIDStruct magicID = address_MAGicIDStruct[ua];
      return (magicID.bm_rightfinger_1, magicID.bm_rightfinger_2, magicID.bm_rightfinger_3, magicID.bm_rightfinger_4, magicID.bm_rightfinger_5);
    }

    function getBioLeftFingers(string _bg_uin) returns (string ret_bm_leftfinger_1,
      string ret_bm_leftfinger_2,
      string ret_bm_leftfinger_3,
      string ret_bm_leftfinger_4,
      string ret_bm_leftfinger_5) {
      address ua = uin_UserAddress[_bg_uin];
      MAGicIDStruct magicID = address_MAGicIDStruct[ua];
      return (magicID.bm_leftfinger_1, magicID.bm_leftfinger_2, magicID.bm_leftfinger_3, magicID.bm_leftfinger_4, magicID.bm_leftfinger_5);
    }

    function revokeID() returns (bool revokeIDStatus) {
    }

    function getIDAccessors(string _bg_uin) returns (AccessAgencyStruct[] getIDAccessorsArray) {
      address[] AccessorsArray = MagicIDUIN_AgencyAddress[_bg_uin];
    }

    function nameResolveAgency(address _agencyAddress) returns (string retAgencyName, string retAgencyDomain) {
      AcessAgencyStruct agency = address_AccessAgencyStruct[_agencyAddress];
      return (agency.agency_name, agency.agency_domain);
    }

    function setAgencyAccess() returns (bool setAgencyAccessStatus) {

    }

    function createAccessAgency(string _agency_id,
      string _agency_name,
      string _agency_domain,
      bool _isAllowedName,
      bool _isAllowedGender,
      bool _isAllowedDOB,
      bool _isAllowedParentName,
      bool _isAllowedAddress,
      bool _isAllowedMobile,
      bool _isAllowedEmail,
      bool _isAllowedCurrentLoc,
      bool _isAllowedBioIRIS,
      bool _isAllowedBioFace,
      bool _isAllowedBioRightFingers,
      bool _isAllowedBioLeftFingers) returns (bool createAccessAgencyStatus) {
      var agency = address_AccessAgencyStruct[msg.sender];
      agency.agency_id = _agency_id;
      agency.agency_name = _agency_name;
      agency.agency_domain = _agency_domain;
      agency.isAllowedName = _isAllowedName;
      agency.isAllowedGender = _isAllowedGender;
      agency.isAllowedDOB = _isAllowedDOB;
      agency.isAllowedParentName = _isAllowedParentName;
      agency.isAllowedAddress = _isAllowedAddress;
      agency.isAllowedMobile = _isAllowedMobile;
      agency.isAllowedEmail = _isAllowedEmail;
      agency.isAllowedCurrentLoc = _isAllowedCurrentLoc;
      agency.isAllowedBioIRIS = _isAllowedBioIRIS;
      agency.isAllowedBioFace = _isAllowedBioFace;
      agency.isAllowedBioRightFingers = _isAllowedBioRightFingers;
      agency.isAllowedBioLeftFingers = _isAllowedBioLeftFingers;

      AccessAgencyArray.push(agency);
      return true;
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

    event IDAccessed(address from, MAGicIDStruct whichID);
}
