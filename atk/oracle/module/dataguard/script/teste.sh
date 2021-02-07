array=("unregister" "register" "validate" "chaveamento" "bolha")
elem_aux=$1
export elem=$(echo $elem_aux |  tr '[:upper:]' '[:lower:]')
echo $elem

if c=$'\x1E' && p="${c}${elem} ${c}" && [[ ! "${array[@]/#/${c}} ${c}" =~ $p ]]; then
echo "OPERATION $elem not valid"
exit 1
else
echo "OPERATION operation selected for execution : " $elem 
fi
