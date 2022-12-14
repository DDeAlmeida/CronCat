#!/bin/bash
echo "
+----------------------------------------------------------------------
| PING & CRONCAT NEAR VALIDATOR INSTALL
| Version: 0.9 (27/07/2022)
+----------------------------------------------------------------------
| Copyright © 2021 All rights reserved.
+----------------------------------------------------------------------
|
+----------------------------------------------------------------------
";sleep 1

homedir=$HOME

networkSelect()
{
  PS4="Enter a number: "
  options=("Testnet" "Guildnet" "Mainnet" "Shardnet")
  select opt in "${options[@]}"
  do
    case $opt in
       "Testnet")
         NETWORK="testnet"
         POOL='.pool.f863973.m0'
         ACCOUNT='.testnet'
         CONTRACT='manager_v1.croncat.testnet'
         break
         ;;
       "Guildnet")
         NETWORK="guildnet"
         POOL='.stake.guildnet'
         CONTRACT='manager_v1.croncat.guildnet'
         ACCOUNT='.guildnet'
         break
         ;;
       "Mainnet")
         NETWORK="mainnet"
         POOL='.poolv1.near'
         ACCOUNT='.near'
         CONTRACT='manager_v1.croncat.near'
         break
         ;;
       "Shardnet")
         NETWORK="shardnet"
         POOL='.factory.shardnet.near'
         ACCOUNT='.shardnet.near'
         CONTRACT='manager_v1.croncat.shardnet.near'
         break
         ;;
       *) echo "invalid option $REPLY";;  

    esac
  done

}

cronTab()
{
PING=$homedir/ping.sh
if [ -f "$PING" ]; then
  echo "Ping file alread exists. Removing.."
  rm $PING
else
  echo "Creating ping file.."
  sleep 0.2
fi  
cat >> $homedir/ping.sh << EOF
#!/bin/bash
export NEAR_ENV=$NETWORK
near call $p$POOL ping '{}' --accountId $a$ACCOUNT --gas=300000000000000
EOF
  echo 'Creating Ping.sh ...'
  sleep 0.3
  chmod +x $homedir/ping.sh
  echo 'Adding to crontab..'
  sleep 0.3
  # Adding to Cron
  crontab -l > mycron
  # echo new cron into cron file
  echo "0 */1 * * * $homedir/ping.sh >> $homedir/near.log 2>&1" >> mycron
  # install new cron file
  crontab mycron
  rm -f mycron
}

cronSelect()
{
  PS4="Enter a number: "
  options=("CronCat" "Crontab")
  select opt in "${options[@]}"
  do
    case $opt in
       "CronCat")
        near view $CONTRACT get_hash '{"contract_id": "'$p$POOL'","function_id": "ping","cadence": "0 0 * * * *","owner_id": "'$a$ACCOUNT'"}' > pingtemp 2>&1
        TASKHASH=$(cat pingtemp | sed -n '2p' | tr -d \')
        rm pingtemp
        near view $CONTRACT get_task '{"task_hash": "'$TASKHASH'"}' > pingtemp 2>&1
        TASK=$(cat pingtemp | grep $p$POOL)
        rm pingtemp
        if [ -z "$TASK" ]
        then
          echo 'Creating Croncat task in '$NETOWRK' network with pool: '$p$POOL' and account: '$a$ACCOUNT
          echo '5 NEAR will be taken from your wallet to create a task in Croncat. Do you agree?'
          select i in yes no
          do
            case $i in
              yes) sleep 0.3
                   near call $CONTRACT create_task '{"contract_id": "'$p$POOL'","function_id": "ping","cadence": "0 0 * * * *","recurring": true,"deposit": "0","gas": 9000000000000}' --accountId $a$ACCOUNT --amount 5
                   echo -e "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n @@@@@@@@(((((@@@@@(((((((((((((((((((((((((((((((((((((((((((((@@@@@(((((&&#((@@\n @@@@@@&@((((((((((@@%(((((((((((((((((((((((((((((((((((((((@@@((((((((((&&#((@@\n @@@@@@@@&&@@@@@     @@@@@%(((((((((((((((((((((((((((((&&&@@(((((@@@@@&&&&&#((@@\n @@@@@@&&%%@@@@@@@@     ..@@@(((((((((((((((((((((((((&&((((((((@@@@@@@%%%&&#((@@\n @@@@@&&&..&&&@@@@@@@     ...@@@@@@@@@@@@@@@@@@@@@@@@@(((((((@@@@@@@@@@(((&&#((@@\n @@@@@&&&  ###&&@@@@@&&&       ........((((((((((((((((((((@@@@@@@@@@%%(((&&#((@@\n @@@@@&&&     ..,,,//###,.             ((((((((((((((((((((%%###((((((((((%%#((@@\n @@@@@&&&            ...               (((((((((((((((((((((((((((((((((((%%#((@@\n @@@@@&&&                              (((((((((((((((((((((((((((((((((((%%#((@@\n @@@@@&&&                                (((((((((((((((((((((((((((((((((%%#((@@\n @@@@@&&&                                (((((((((((((((((((((((((((((((((##(((@@\n @@@@@&&&                                ((((((((((((((((((((((((((((((((((((((@@\n @@@@&///                                (((((((((((((((((((((((((((((((((((&&&@@\n @@@@&,,,                                   ((((((((((((((((((((((((((((((((&&&@@\n @@@@&                                      ((((((((((((((((((((((((((((((((&%%@@\n @@@&&               @@@@@@@@,,...          ((((((((((@@@@@@@(((((((((((((((&%%@@\n @@@&&             @@        @@...            (((((@@@(((((((@@@((((((((((((%%%@@\n &&&((                                        (((((((((((((((((((((((((((((((((@@\n &&&..                              @@@@@@@@@@   ((((((((((((((((((((((((((((((&&\n &&&..                              ...@@@@@..     ((((((((((((((((((((((((((((@@\n &&&..                                 ,,,,,            (((((((((((((((((((((((@@\n &&&,,...                              .....               ((((((((((((((((((((@@\n &&&&&,,,                         .....@@@@@.....               ((((((((((((&&&@@\n @@@&&@@@..             //%%%.....@@@@@&&&&&@@@@@.....%%///          (((((&&#%%@@\n @@@@@&&&@@...            ,,,@@@@@&&&&&%%%%%&&&&&@@@@@,,             ..@&&%%(((@@\n @@@@@@@@**&&&,,...       ...,,@@@%%%%%##%%%%%%%%@@,,,..          ...&&(%#(((((@@\n @@@@@@@@  ,,,&&,,,..        ..@@@%%%%%((%%%%%%%%@@...       ...,,&&&##%(((((((@@\n @@@@@@@@@@@@@%%&&&%%,,,.....  ...@@   %%%%%  @@@..        ,,%%%&&%%%@@@@@@@@@@@@\n @@@@@@@@@@@@@@@%%%##&&&%%,,,,,...  @@@@@@@@@@.  ..**,((%%%&&%##%%%@@@@@@@@@@@@@@\n @@@@@@@@@@@@@@@@@@@@%%%##&&&&&%%%,,,,,,,,,,,,,,,%%&&&&&%##%%%@@@@@@@@@@@@@@@@@@@\n @@@@@@@@@@@@@@@@@@@@@@@@@&&&%%###&&&&&&&&&&&&&&&##%%%&&&@@@@@@@@@@@@@@@@@@@@@@@@\n"
        
                   break
                   ;;
              no) echo 'Croncat task has not been created.'
                   break 
                   ;;
            esac
          done
          else
          echo 'Croncat task with pool: '$p$POOL' already installed.'  
          echo "-----------------" 
        fi  
         break
         ;;
       "Crontab")
        cronTab
         break
         ;;

    esac
  done

}

main()
{
  networkSelect
  sleep 0.5
  echo 'Enter your pool name (example: chester-validator)'
  read p
  p=${p%%$POOL}
  sleep 0.5
  echo '----------'
  echo "Enter account name (example: chester)"
  read a
  a=${a%%$ACCOUNT}
  sleep 0.5
  echo '----------'
  echo 'Want to use croncat or crontab?'
  sleep 0.5
  echo '----------'
  cronSelect




  echo 'Selected network: '$NETWORK
  echo 'Your pool: '$p$POOL
  echo 'Your account: '$a$ACCOUNT
  echo '----------------------------'
  echo 'Do you want install CronCat Agent? Check it out: https://docs.cron.cat/docs/agent-cli/'
    PS4="Enter a number: "
    options=("Yes" "No")
    select opt in "${options[@]}"
    do
      case $opt in
         "Yes")
           createAgent
           break
           ;;
         "No")
           sleep 1
           echo "Ping Installed!"
           break
           ;;
          *) echo "invalid option $REPLY";; 

      esac
    done


}

createAgent()
{
  echo 'Installing Croncat..'
  sleep 0.5
  AVERSION=$(curl -s https://github.com/Cron-Near/croncat/releases/latest |  grep -Eo "[0-9].[0-9]*.[0-9]")
  IVERSION=$(croncat --version)
  if [ -n $IVERSION ]
  then
    echo 'Croncat Agent already installed'
    if [[ "$AVERSION" == "$IVERSION"  ]]
    then
     echo 'You have the latest version installed.'
     echo 'Installed Croncat version: '$IVERSION
    else
     echo 'You have an old version installed. Updating..'
     sleep 0.3
     npm i -g croncat
     echo 'Updated! New version: '$AVERSION
    fi
  else 
    npm i -g croncat
    echo 'Registering Agent..'
    sleep 0.5
    croncat register $a$ACCOUNT $a$ACCOUNT
  fi  


  
 
}


main