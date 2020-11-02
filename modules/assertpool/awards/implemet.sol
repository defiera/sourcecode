pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

contract AssertPoolAwardsImpl is AssertPoolAwardsState {

    modifier ControllerOnly {
        require( _CTL == ControllerDelegate(msg.sender), "InvalidOperation");
        _;
    }

    function _pauseable() internal view returns (bool) {
        return deadlineTime != 0 && now > deadlineTime;
    }

    function pauseable() external returns (bool) {
        return _pauseable();
    }

    
    function CTL_CountDownApplyBegin() external ControllerOnly returns (bool) {

        
        if ( isInCountdowning ) {
            return false;
        }

        
        isInCountdowning = true;

        
        deadlineTime = now + countdownTime;

        return true;
    }

    
    function CTL_CountDownStop() external ControllerOnly returns (bool) {
        if ( isInCountdowning ) {
            isInCountdowning = false;
            deadlineTime = 0;
        }
    }

    
    function CTL_InvestQueueAppend(OrderInterface o) external ControllerOnly {

        
        require(!_pauseable());

        
        investOrdersQueue.push(o);

        
        if ( isInCountdowning ) {

            
            if ( now < deadlineTime ) {
                
                
                deadlineTime += usdtInterface.balanceOf(address(o)) / additionalAmountMin * additionalTime;
                if ( deadlineTime > now + countdownTime ) {
                    deadlineTime = now + countdownTime;
                }
            }
            
            else {
                isInCountdowning = false;
            }
        }
    }

    
    function OwnerDistributeAwards() external KOwnerOnly {

        
        require( _pauseable() );

        
        phInterface.ASTPoolAward_PushNewStateVersion();

        
        uint totalAwards = apInterface.Allowance(address(this));

        
        uint totalCurrent = totalAwards;

        
        
        for (
            (uint desc, int j) = (0, int(investOrdersQueue.length - 1));
            j >= 0 && totalCurrent > 0 && desc < luckyDoyTotalCount;
            (desc++, j--)
        ) {
            
            uint award = investOrdersQueue[uint(j)].totalAmount() * specialRewardsDescMapping[desc];
            if ( award == 0 ) {
                award = investOrdersQueue[uint(j)].totalAmount() * defualtProp;
            }

            
            uint maxLimit = totalAwards * specialPropMaxlimitMapping[desc] / 1 szabo;
            if ( maxLimit == 0 ) {
                maxLimit = totalAwards * propMaxLimit / 1 szabo;
            }

            
            if ( award > maxLimit ) {
                award = maxLimit;
            }

            
            if ( award > totalCurrent ) {
                award = totalCurrent;
                totalCurrent = 0;
            } else {
                totalCurrent -= award;
            }

            if ( award > 0 ) {

                address luckDogAddress = investOrdersQueue[uint(j)].contractOwner();

                LuckyDog storage ld = luckydogMapping[luckDogAddress];
                ld.award += award;
                ld.time = now;
                ld.canwithdraw = true;

                emit Log_Luckdog(luckDogAddress, award);
            }
        }

        death = true;
    }

    function IsLuckDog(address owner) external returns (bool isluckDog, uint award, bool canwithdrawable) {

        isluckDog = (now - luckydogMapping[owner].time <= 30 days);

        if ( isluckDog ) {
            award = luckydogMapping[owner].award;
            canwithdrawable = luckydogMapping[owner].canwithdraw;
        }

        
    }

    function WithdrawLuckAward() external returns ( uint award ) {

        
        
        if (
            now - luckydogMapping[msg.sender].time < 30 days &&
            luckydogMapping[msg.sender].canwithdraw &&
            luckydogMapping[msg.sender].award > 0
        ) {
            award = luckydogMapping[msg.sender].award;
            luckydogMapping[msg.sender].canwithdraw = false;
            luckydogMapping[msg.sender].award = 0;
            luckydogMapping[msg.sender].time = 0;

            apInterface.OperatorSend(msg.sender, award);
        }
    }

    
    function SetCountdownTime(uint time) external KOwnerOnly {
        countdownTime = time;
    }

    
    function SetAdditionalAmountMin(uint min) external KOwnerOnly {
        additionalAmountMin = min;
    }

    
    function SetAdditionalTime(uint time) external KOwnerOnly {
        additionalTime = time;
    }

    
    function SetLuckyDoyTotalCount(uint count) external KOwnerOnly {
        luckyDoyTotalCount = count;
    }

    
    function SetDefualtProp(uint multi) external KOwnerOnly {
        defualtProp = multi;
    }

    
    function SetPropMaxLimit(uint limit) external KOwnerOnly {
        propMaxLimit = limit;
    }

    
    function SetSpecialProp(uint n, uint p) external KOwnerOnly {
        specialRewardsDescMapping[n] = p;
    }

    
    function SetSpecialPropMaxLimit(uint n, uint p) external KOwnerOnly {
        specialPropMaxlimitMapping[n] = p;
    }
}
