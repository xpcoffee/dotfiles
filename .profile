# This file sets up PATH and other environment variables

#== MISC ENVIRONMENT VARIABLES ==
wp="/home/rick/Documents/Code"

#== PATH ==
if [ -d "$HOME/bin" ] ; then
   PATH="$HOME/bin:$PATH"
fi
PATH="/snap/bin:$PATH"
PATH="$HOME/share/bin:$PATH"
PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export PATH
