if df_ver >= 4000 and df_ver <= 4199 then --dfver:4000-4199
	require 'remote.compat_40'
end

if df_ver >= 4300 and df_ver <= 4399 then --dfver:4300-4399
	require 'remote.compat_43'
end