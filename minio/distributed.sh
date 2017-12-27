export MINIO_ACCESS_KEY=miniominio
export MINIO_SECRET_KEY=miniominiominio
~/minio server \
	http://[server1_IP]/home/minio/minio_A \
	http://[server1_IP]/home/minio/minio_B \
	http://[server1_IP]/home/minio/minio_C \
	http://[server1_IP]/home/minio/minio_D \
	http://[server2_IP]/home/minio/minio_A \
	http://[server2_IP]/home/minio/minio_B \
	http://[server2_IP]/home/minio/minio_C \
	http://[server2_IP]/home/minio/minio_D \
	http://[server3_IP]/home/minio/minio_A \
	http://[server3_IP]/home/minio/minio_B \
	http://[server3_IP]/home/minio/minio_C \
	http://[server3_IP]/home/minio/minio_D
