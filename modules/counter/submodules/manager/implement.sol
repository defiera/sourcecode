pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

contract CounterManagerImpl is CounterManagerState {

    modifier AuthorizedOnly() {
        require(msg.sender == authorizedAddress); _;
    }

    
    function WhenOrderCreatedDelegate(OrderInterface order)
    external AuthorizedOnly returns (uint, address[] memory, uint[] memory, AwardType[] memory) {

        address owner = order.contractOwner();
        uint orderAmount = order.totalAmount();

        
        if ( !vaildAddressMapping[owner] ) {
            
            vaildAddressMapping[owner] = true;
            
            vaildAddressCountMapping[RLTInterface.GetIntroducer(owner)]++;
        }

        
        selfAchievementMapping[owner] += orderAmount;

        
        if ( dlevelMapping[owner] == 0 ) {
            if (orderAmount >= dlv1DepositedNeed ) {
                depositedGreatThanD1[owner] = true;
            } else if ( orderAmount >= 5000 * 10 ** 6 ) {
                depositedGreatThan5000USD[owner] = true;
            }
        }
    }

    
    function WhenOrderFrozenDelegate(OrderInterface order)
    external AuthorizedOnly returns (uint len, address[] memory addresses, uint[] memory awards, AwardType[] memory types) {

        
        
        

        
        
        len = dlevelAwarProp.length * 4;
        addresses = new address[](len);
        awards = new uint[](len);
        types = new AwardType[](len);

        
        uint[] memory awarProps = dlevelAwarProp;

        
        
        address owner = order.contractOwner();

        
        address root = RLTInterface.rootAddress();

        
        for (
            (uint i, address parent) = (0, RLTInterface.GetIntroducer(owner) );
            i < dlvDepthMaxLimit && parent != address(0x0) && parent != root;
            (parent = RLTInterface.GetIntroducer(parent), i++)
        ) {
            uint8 dlv = dlevelMapping[parent];

            
            if ( addresses[dlv] != address(0x0) ) {
                continue;
            }

            uint psum = 0;

            
            for ( uint8 x = dlv; x > 0; x-- ) {
                psum += awarProps[x];
                awarProps[x] = 0;
            }

            if ( psum > 0 ) {

                addresses[dlv] = parent;
                awards[dlv] = order.totalAmount() * psum / 1 szabo;
                types[dlv] = AwardType.Manager;

                
                for (
                    (uint j, address grower) = (0, RLTInterface.GetIntroducer(parent));
                    j < 3 && grower != address(0x0) && grower != root;
                    (grower = RLTInterface.GetIntroducer(grower), j++)
                ) {
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    if ( dlevelMapping[grower] <= dlv && dlevelMapping[grower] >= 2 ) {

                        uint offset = 6 + dlv * 3 + j;

                        addresses[offset] = grower;

                        
                        awards[offset] = awards[dlv] * 0.1 szabo / 1 szabo;

                        types[offset] = AwardType.Grow;
                    }
                }
            }

            
            if ( dlv >= dlevelAwarProp.length - 1 ) {
                break;
            }
        }
    }

    
    function WhenOrderDoneDelegate(OrderInterface order)
    external AuthorizedOnly returns (uint len, address[] memory addresses, uint[] memory awards, AwardType[] memory types) {

        
        
        

        
        uint profit = (order.getHelpedAmountTotal() - order.totalAmount());

        
        address owner = order.contractOwner();

        
        address root = RLTInterface.rootAddress();

        
        len = RLTInterface.Depth(owner);
        
        if ( len > awardProp.length ) {
            len = awardProp.length;
        }

        
        addresses = new address[](len);
        awards = new uint[](len);
        types = new AwardType[](len);

        
        for (
            (uint i, address parent) = (0, RLTInterface.GetIntroducer(owner) );
            i < len && parent != address(0x0) && parent != root;
            (parent = RLTInterface.GetIntroducer(parent), i++)
        ) {
            
            
            if (
                dlevelMapping[parent] > 0 || 
                vaildAddressCountMapping[parent] >= i + 1 || 
                vaildAddressCountMapping[parent] >= 9 
            ) {
                addresses[i] = parent;
                awards[i] = profit * awardProp[i] / 1 szabo;
                types[i] = AwardType.Admin;
            }
        }
    }

    
    function InfomationOf(address owner) external returns (
        
        bool isvaild,
        
        uint vaildMemberTotal,
        
        uint selfAchievements,
        
        uint dlevel
    ) {
        return (
            vaildAddressMapping[owner],
            vaildAddressCountMapping[owner],
            selfAchievementMapping[owner],
            uint(dlevelMapping[owner])
        );
    }

    
    function UpgradeDLevel() external returns (uint origin, uint current) {

        origin = dlevelMapping[msg.sender];
        current = origin;

        
        if ( origin == dlevelAwarProp.length - 1 ) {
            return (origin, current);
        }

        if ( current == 0 ) {
            if (
                depositedGreatThanD1[msg.sender] ||
                (
                    vaildAddressMapping[msg.sender] &&
                    vaildAddressCountMapping[msg.sender] >= 10 &&
                    depositedGreatThan5000USD[msg.sender]
                )
            ) {
                current = 1;
            }
        }

        
        (address[] memory directAddresses, uint len) = RLTInterface.RecommendList(msg.sender);

        
        uint[] memory childrenDLVSCount = new uint[](dlevelAwarProp.length);

        
        
        for ( uint i = 0; i < len; i++) {
            childrenDLVSCount[dlevelMemberMaxMapping[directAddresses[i]]]++;
        }

        
        
        if ( current == 1 ) {
            uint effCount = 0;
            for (uint i = current; i < dlevelAwarProp.length; i++ ) {
                effCount += childrenDLVSCount[i];
            }
            if ( effCount >= 2 ) {
                current = 2;
            }
        }

        
        if ( current == 2 ) {
            uint effCount = 0;
            for (uint i = current; i < dlevelAwarProp.length; i++ ) {
                effCount += childrenDLVSCount[i];
            }
            if ( effCount >= 2 ) {
                current = 3;
            }
        }

        
        if ( current == 3 ) {
            uint effCount = 0;
            for (uint i = current; i < dlevelAwarProp.length; i++ ) {
                effCount += childrenDLVSCount[i];
            }
            if ( effCount >= 3 ) {
                current = 4;
            }
        }

        
        if ( current == 4 ) {
            uint effCount = 0;
            for (uint i = current; i < dlevelAwarProp.length; i++ ) {
                effCount += childrenDLVSCount[i];
            }
            if ( effCount >= 3 ) {
                current = 5;
            }
        }

        
        if ( current > origin ) {

            
            dlevelMapping[msg.sender] = uint8(current);

            
            address root = RLTInterface.rootAddress();
            for (
                (uint i, address parent) = (0, msg.sender);
                
                i < 10 && parent != address(0x0) && parent != root;
                (parent = RLTInterface.GetIntroducer(parent), i++)
            ) {
                if ( dlevelMemberMaxMapping[parent] < current ) {
                    dlevelMemberMaxMapping[parent] = uint8(current);
                }
            }
        }

        return (origin, current);
    }

    
    function PaymentDLevelOne() external returns (bool) {

        
        require( RLTInterface.GetIntroducer(msg.sender) != address(0x0) );

        
        if ( dlevelMapping[msg.sender] != 0 ) {
            return false;
        }

        
        if ( usdtInterface.balanceOf(msg.sender) < dlv1Prices ) {
            return false;
        }

        dlevelMapping[msg.sender] = 1;

        
        address root = RLTInterface.rootAddress();
        for (
            (uint i, address parent) = (0, msg.sender);
            i < 10 && parent != address(0x0) && parent != root;
            (parent = RLTInterface.GetIntroducer(parent), i++)
        ) {
            if ( dlevelMemberMaxMapping[parent] < 1 ) {
                dlevelMemberMaxMapping[parent] = 1;
            }
        }

        
        usdtInterface.operatorSend(msg.sender, _KContractOwners[0], dlv1Prices, "", "PaymentDLevel");

        return true;
    }

    
    function SetRecommendAwardProp(uint l, uint p) external KOwnerOnly {
        require( l >= 0 && l < awardProp.length );
        awardProp[l] = p;
    }

    
    function SetDLevelAwardProp(uint dl, uint p) external KOwnerOnly {
        require( dl >= 1 && dl < dlevelAwarProp.length );
        dlevelAwarProp[dl] = p;
    }

    
    function SetDLevelSearchDepth(uint depth) external KOwnerOnly {
        dlvDepthMaxLimit = depth;
    }

    
    function SetDlevel1DepositedNeed(uint need) external KOwnerOnly {
        dlv1DepositedNeed = need;
    }

    
    function SetDLevel1Prices(uint prices) external KOwnerOnly {
        dlv1Prices = prices;
    }

    
    
    
    
    
    
    
    
    
    function ImportDLevel(
        address sender,
        uint8 lv,
        uint selfAchievement,
        uint vaildMemberTotal
    ) external KOwnerOnly {

        
        selfAchievementMapping[sender] = selfAchievement;

        
        if ( selfAchievement > 0 ) {
            vaildAddressMapping[sender] = true;
        }

        
        vaildAddressCountMapping[sender] = vaildMemberTotal;

        
        
        dlevelMapping[sender] = lv;
        address root = RLTInterface.rootAddress();
        for (
            (uint i, address parent) = (0, sender);
            i < 10 && parent != address(0x0) && parent != root;
            (parent = RLTInterface.GetIntroducer(parent), i++)
        ) {
            if ( dlevelMemberMaxMapping[parent] < lv ) {
                dlevelMemberMaxMapping[parent] = lv;
            }
        }
    }
}
