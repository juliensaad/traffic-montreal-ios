
for i in `find . -name "*.gif" -o -name "*.jpg"`; do
file=`basename -s .jpg "$i" | xargs basename -s .png | xargs basename -s @2x`
result=`ack -i "$file"`
if [ -z "$result" ]; then
echo "$i"
fi
done