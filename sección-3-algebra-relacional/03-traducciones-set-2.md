$\sigma_{src='Chennai' ,\wedge, dest='New Delhi'}(flight)$
$\sigma_{src='Chennai' ,\wedge, dest='New Delhi'}(flight)$
$\pi_{fid}\bigl(\sigma_{pid=123}(booking) \bowtie \sigma_{dest='Chennai'}(flight)\bigr)$
$\pi_{aname}\bigl(agency \bowtie_{agency.acity = passenger.pcity} \sigma_{pid=123}(passenger)\bigr)$
$\bigl(\sigma_{fdate='2020-12-01' \wedge time='16:00'}(flight)\bigr);\cup;\bigl(\sigma_{fdate='2020-12-02' \wedge time='16:00'}(flight)\bigr)$
$\pi_{aname}(agency);-;\pi_{aname}\bigl(agency \bowtie \sigma_{pid=123}(booking)\bigr)$
